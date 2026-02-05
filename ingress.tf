# resource "helm_release" "nginx_ingress" {
#   name       = "nginx-ingress"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   namespace  = "ingress-nginx"
#   create_namespace = true

#   set {
#     name  = "service.type"
#     value = "LoadBalancer"
#   }
# }
