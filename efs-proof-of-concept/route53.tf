resource "aws_route53_zone" "poc_net" {
  name = "poc.net"

  vpc {
    vpc_id = local.vpc_id
  }
}

resource "aws_route53_record" "rsync_poc_net" {
  zone_id = aws_route53_zone.poc_net.zone_id
  name = "rsync"
  type = "A"

  alias {
    name = aws_lb.internal_lb.dns_name
    zone_id = aws_lb.internal_lb.zone_id
    evaluate_target_health = false
  }

  allow_overwrite = true
}