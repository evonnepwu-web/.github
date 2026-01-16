# ===========================================
# DNS Management (Route53)
# Automates record updates when CloudFront changes
# ===========================================

# 1. Get the Hosted Zone ID for the domain
# Assumes the zone is already created in Route53 via Console or Registrar
data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# 2. Root Domain Alias (e.g., evoger.tw -> CloudFront)
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

# 3. WWW Subdomain Alias (e.g., www.evoger.tw -> CloudFront)
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A" # Alias is preferred over CNAME for AWS targets for performance/cost

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}
