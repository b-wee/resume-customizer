---
company: Meridian Health
title: Senior Software Engineer
location: Austin, TX (remote)
start: 2021-06
end: present
---
# Raw description

Meridian is a ~300 person health-tech company, patient billing platform. I'm on the
payments team (5 engineers), and de facto tech lead since mid-2023.

The big one: led the migration off our legacy Stripe integration to a multi-processor
setup (Stripe + Adyen). This was about 14 months of work. I designed the abstraction
layer, wrote the RFC, drove it through arch review. We moved roughly $40M/year of
payment volume with zero downtime — did it with a double-write shadow mode and
per-merchant cutover flags. Declined-payment rate dropped 1.8 points because of
smart routing between processors.

Also: built the retry/dunning system for failed patient payments in Python/Celery.
Recovered about $2.1M in the first year that would previously have gone to collections.

I run our on-call rotation, cut mean incident resolution from ~90 min to ~35 min
by building runbooks and better Datadog alerting. Mentored 4 junior engineers,
two got promoted. Interview a lot — probably 150+ technical interviews.

Tech: Python (Django), Go for the routing service, Postgres, Kafka for payment
events, AWS ECS, Terraform.
