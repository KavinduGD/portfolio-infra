# ACM Certificate Resource
resource "aws_acm_certificate" "kavindu_gihan_online_cert" {

  domain_name               = "kavindu-gihan.online"
  subject_alternative_names = ["*.kavindu-gihan.online"]


  validation_method = "DNS"

  tags = {
    name         = "kavindu-gihan-online-cert"
    project_name = "porfolio"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# DNS Validation Record
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.kavindu_gihan_online_cert.domain_validation_options : dvo.domain_name => dvo
  }

  allow_overwrite = true
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  type            = each.value.resource_record_type
  zone_id         = aws_route53_zone.kavindu_gihan_online_zone.id
}

# Certificate Validation
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.kavindu_gihan_online_cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation :
    record.fqdn
  ]
}
