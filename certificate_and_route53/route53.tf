resource "aws_route53_zone" "kavindu_gihan_online_zone" {
  name = "kavindu-gihan.online"

  tags = {
    project_name = "porfolio"
  }
}



# resource "aws_route53_record" "backend" {
#   zone_id = aws_route53_zone.kts-hosted-zone.zone_id
#   name    = "kts-backend.kavindu-gihan.tech"
#   type    = "A"

#   alias {
#     name                   = aws_lb.depl_lb.dns_name
#     zone_id                = aws_lb.depl_lb.zone_id
#     evaluate_target_health = true
#   }
# }