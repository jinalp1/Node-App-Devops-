provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "kubeapp" {
  metadata {
    name = "kubeapp-namespace"
  }
}

resource "kubernetes_deployment" "nodejs" {
  metadata {
    name      = "nodejs-deployment"
    namespace = kubernetes_namespace.kubeapp.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nodejs"
      }
    }
    template {
      metadata {
        labels = {
          app = "nodejs"
        }
      }
      spec {
        container {
          name  = "nodejs"
          image = "jinalpadhiar15@gmail.com/e-commerce-api-app:latest"
          port {
            container_port = 8080
          }
          env {
            name  = "MONGO_URL"
            value = "mongodb://127.0.0.1:27017/"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nodejs" {
  metadata {
    name      = "nodejs-service"
    namespace = kubernetes_namespace.kubeapp.metadata[0].name
  }
  spec {
    selector = {
      app = "nodejs"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "mongo" {
  metadata {
    name      = "mongo-deployment"
    namespace = kubernetes_namespace.kubeapp.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mongo"
      }
    }
    template {
      metadata {
        labels = {
          app = "mongo"
        }
      }
      spec {
        container {
          name  = "mongo"
          image = "mongo:latest"
          port {
            container_port = 27017
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongo" {
  metadata {
    name      = "mongo-service"
    namespace = kubernetes_namespace.kubeapp.metadata[0].name
  }
  spec {
    selector = {
      app = "mongo"
    }
    port {
      port        = 27017
      target_port = 27017
    }
    type = "ClusterIP"
  }
}
