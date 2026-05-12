terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


# ═══════════════════════════════════════════════════════════════
# Component 1/18 · seeded from L1-001
# ═══════════════════════════════════════════════════════════════

resource "aws_instance" "comp1_instance-bffi9p" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-bffi9p"
  }
}

resource "aws_ebs_volume" "comp1_ebs-volume-tqh0zj" {
  availability_zone = "ap-northeast-2a"
  size              = 500
  type              = "gp2"

  encrypted = true

  tags = {
    Name = "ebs-volume-tqh0zj"
    AttachedTo = "stopped_instance"
  }
}

resource "aws_ebs_volume" "comp1_ebs-volume-kvsc6k" {
  availability_zone = "ap-northeast-2a"
  size              = 500
  type              = "gp2"

  encrypted = true

  tags = {
    Name = "ebs-volume-kvsc6k"
    AttachedTo = "stopped_instance"
  }
}

resource "aws_ebs_volume" "comp1_ebs-volume-qr5yxx" {
  availability_zone = "ap-northeast-2a"
  size              = 500
  type              = "gp2"

  encrypted = true

  tags = {
    Name = "ebs-volume-qr5yxx"
    AttachedTo = "stopped_instance"
  }
}

resource "aws_instance" "comp1_instance-rvv5yf" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-rvv5yf"
  }
}

resource "aws_instance" "comp1_instance-jkyn5j" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-jkyn5j"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/18 · seeded from L1-005
# ═══════════════════════════════════════════════════════════════

resource "aws_lb" "comp2_lb-q6rd7h" {
  name               = "lb-q6rd7h"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-q6rd7h_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-q6rd7h"
  }
}

resource "aws_lb" "comp2_lb-k2x50d" {
  name               = "lb-k2x50d"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-k2x50d_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-k2x50d"
  }
}

resource "aws_lb" "comp2_lb-gs6py1" {
  name               = "lb-gs6py1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-gs6py1_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-gs6py1"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 3/18 · seeded from L1-008
# ═══════════════════════════════════════════════════════════════

resource "aws_ami" "comp3_ami-taji2b" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-taji2b"
  }
}
resource "aws_ami" "comp3_ami-fhpl2u" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-fhpl2u"
  }
}
resource "aws_ami" "comp3_ami-9l1xhl" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-9l1xhl"
  }
}
resource "aws_ami" "comp3_ami-wsxnaq" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-wsxnaq"
  }
}
resource "aws_ami" "comp3_ami-b2guat" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-b2guat"
  }
}
resource "aws_ami" "comp3_ami-72l0q6" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-72l0q6"
  }
}
resource "aws_ami" "comp3_ami-setyp5" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-setyp5"
  }
}
resource "aws_ami" "comp3_ami-3e90d3" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-3e90d3"
  }
}
resource "aws_ami" "comp3_ami-rkrecs" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-rkrecs"
  }
}
resource "aws_ami" "comp3_ami-vx1usm" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-vx1usm"
  }
}
resource "aws_ami" "comp3_ami-xg0262" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-xg0262"
  }
}
resource "aws_ami" "comp3_ami-f40sf8" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-f40sf8"
  }
}
resource "aws_ami" "comp3_ami-npj678" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-npj678"
  }
}
resource "aws_ami" "comp3_ami-htfogr" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-htfogr"
  }
}
resource "aws_ami" "comp3_ami-298rpl" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-298rpl"
  }
}
resource "aws_ami" "comp3_ami-d2q8wq" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-d2q8wq"
  }
}
resource "aws_ami" "comp3_ami-gw4i66" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-gw4i66"
  }
}
resource "aws_ami" "comp3_ami-rimfr4" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-rimfr4"
  }
}
resource "aws_ami" "comp3_ami-cabu99" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-cabu99"
  }
}
resource "aws_ami" "comp3_ami-ukb8bm" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-ukb8bm"
  }
}
resource "aws_ami" "comp3_ami-dln1ep" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-dln1ep"
  }
}
resource "aws_ami" "comp3_ami-akbwmq" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-akbwmq"
  }
}
resource "aws_ami" "comp3_ami-hz0rab" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-hz0rab"
  }
}
resource "aws_ami" "comp3_ami-3fu1ic" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-3fu1ic"
  }
}
resource "aws_ami" "comp3_ami-nkzl8q" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-nkzl8q"
  }
}
resource "aws_ami" "comp3_ami-a48t5s" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-a48t5s"
  }
}
resource "aws_ami" "comp3_ami-nwb666" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-nwb666"
  }
}
resource "aws_ami" "comp3_ami-hpr1ix" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-hpr1ix"
  }
}
resource "aws_ami" "comp3_ami-knpdvj" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-knpdvj"
  }
}
resource "aws_ami" "comp3_ami-zipcpm" {
  unused_days = 120
  snapshots_per_ami = 2
  total_snapshot_gb = 600

  tags = {
    Name = "ami-zipcpm"
  }
}
resource "aws_ebs_snapshot" "comp3_ebs-snapshot-b7c8bk" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-b7c8bk"

  tags = {
    Name = "ebs-snapshot-b7c8bk"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-wtfwoj" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-wtfwoj"

  tags = {
    Name = "ebs-snapshot-wtfwoj"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-dees8b" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-dees8b"

  tags = {
    Name = "ebs-snapshot-dees8b"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-2n1lx7" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-2n1lx7"

  tags = {
    Name = "ebs-snapshot-2n1lx7"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ir2cxf" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ir2cxf"

  tags = {
    Name = "ebs-snapshot-ir2cxf"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-7crf8j" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-7crf8j"

  tags = {
    Name = "ebs-snapshot-7crf8j"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-y3fmey" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-y3fmey"

  tags = {
    Name = "ebs-snapshot-y3fmey"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-3bsehs" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-3bsehs"

  tags = {
    Name = "ebs-snapshot-3bsehs"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-81591r" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-81591r"

  tags = {
    Name = "ebs-snapshot-81591r"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ydz252" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ydz252"

  tags = {
    Name = "ebs-snapshot-ydz252"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-vglcwp" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-vglcwp"

  tags = {
    Name = "ebs-snapshot-vglcwp"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-hq6xo0" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-hq6xo0"

  tags = {
    Name = "ebs-snapshot-hq6xo0"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-mr1st0" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-mr1st0"

  tags = {
    Name = "ebs-snapshot-mr1st0"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-i7j9am" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-i7j9am"

  tags = {
    Name = "ebs-snapshot-i7j9am"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-2f1b3c" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-2f1b3c"

  tags = {
    Name = "ebs-snapshot-2f1b3c"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ywu32d" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ywu32d"

  tags = {
    Name = "ebs-snapshot-ywu32d"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-4z0j38" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-4z0j38"

  tags = {
    Name = "ebs-snapshot-4z0j38"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-wq56cb" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-wq56cb"

  tags = {
    Name = "ebs-snapshot-wq56cb"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-sjq7it" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-sjq7it"

  tags = {
    Name = "ebs-snapshot-sjq7it"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-tmr10l" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-tmr10l"

  tags = {
    Name = "ebs-snapshot-tmr10l"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-yeafcm" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-yeafcm"

  tags = {
    Name = "ebs-snapshot-yeafcm"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-rri4m0" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-rri4m0"

  tags = {
    Name = "ebs-snapshot-rri4m0"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-04vbnl" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-04vbnl"

  tags = {
    Name = "ebs-snapshot-04vbnl"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-yo7n5r" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-yo7n5r"

  tags = {
    Name = "ebs-snapshot-yo7n5r"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-vl11tg" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-vl11tg"

  tags = {
    Name = "ebs-snapshot-vl11tg"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-gks7w1" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-gks7w1"

  tags = {
    Name = "ebs-snapshot-gks7w1"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-mvh6x0" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-mvh6x0"

  tags = {
    Name = "ebs-snapshot-mvh6x0"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-uwfrhs" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-uwfrhs"

  tags = {
    Name = "ebs-snapshot-uwfrhs"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-rwqaok" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-rwqaok"

  tags = {
    Name = "ebs-snapshot-rwqaok"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ms4p2s" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ms4p2s"

  tags = {
    Name = "ebs-snapshot-ms4p2s"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-zhzpzi" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-zhzpzi"

  tags = {
    Name = "ebs-snapshot-zhzpzi"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-gtya50" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-gtya50"

  tags = {
    Name = "ebs-snapshot-gtya50"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-kyscnv" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-kyscnv"

  tags = {
    Name = "ebs-snapshot-kyscnv"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-y7isgb" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-y7isgb"

  tags = {
    Name = "ebs-snapshot-y7isgb"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-3x862z" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-3x862z"

  tags = {
    Name = "ebs-snapshot-3x862z"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-v3lmgc" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-v3lmgc"

  tags = {
    Name = "ebs-snapshot-v3lmgc"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ywpm57" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ywpm57"

  tags = {
    Name = "ebs-snapshot-ywpm57"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-7p2xq8" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-7p2xq8"

  tags = {
    Name = "ebs-snapshot-7p2xq8"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-6vvg1i" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-6vvg1i"

  tags = {
    Name = "ebs-snapshot-6vvg1i"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-h4705n" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-h4705n"

  tags = {
    Name = "ebs-snapshot-h4705n"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-l28nso" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-l28nso"

  tags = {
    Name = "ebs-snapshot-l28nso"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-t9ppzx" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-t9ppzx"

  tags = {
    Name = "ebs-snapshot-t9ppzx"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ydv479" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ydv479"

  tags = {
    Name = "ebs-snapshot-ydv479"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-mw0qf6" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-mw0qf6"

  tags = {
    Name = "ebs-snapshot-mw0qf6"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-7stpjf" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-7stpjf"

  tags = {
    Name = "ebs-snapshot-7stpjf"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-1egszi" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-1egszi"

  tags = {
    Name = "ebs-snapshot-1egszi"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-nc0k9h" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-nc0k9h"

  tags = {
    Name = "ebs-snapshot-nc0k9h"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-awqg9d" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-awqg9d"

  tags = {
    Name = "ebs-snapshot-awqg9d"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-oet1an" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-oet1an"

  tags = {
    Name = "ebs-snapshot-oet1an"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-2q26yh" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-2q26yh"

  tags = {
    Name = "ebs-snapshot-2q26yh"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-tdvrz2" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-tdvrz2"

  tags = {
    Name = "ebs-snapshot-tdvrz2"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-rz7qp6" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-rz7qp6"

  tags = {
    Name = "ebs-snapshot-rz7qp6"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-o7w1tt" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-o7w1tt"

  tags = {
    Name = "ebs-snapshot-o7w1tt"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-d9ff1o" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-d9ff1o"

  tags = {
    Name = "ebs-snapshot-d9ff1o"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-jpfxbo" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-jpfxbo"

  tags = {
    Name = "ebs-snapshot-jpfxbo"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-cen6a7" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-cen6a7"

  tags = {
    Name = "ebs-snapshot-cen6a7"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ulpxf9" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ulpxf9"

  tags = {
    Name = "ebs-snapshot-ulpxf9"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-0kdllh" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-0kdllh"

  tags = {
    Name = "ebs-snapshot-0kdllh"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-wj0xt3" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-wj0xt3"

  tags = {
    Name = "ebs-snapshot-wj0xt3"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-uwq1dw" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-uwq1dw"

  tags = {
    Name = "ebs-snapshot-uwq1dw"
  }
}

resource "aws_ami" "comp3_ami-sdyeo3" {
  used_in_launch_template = true

  tags = {
    Name = "ami-sdyeo3"
  }
}
resource "aws_ami" "comp3_ami-2osbrq" {
  used_in_launch_template = true

  tags = {
    Name = "ami-2osbrq"
  }
}
resource "aws_ami" "comp3_ami-cj2pce" {
  used_in_launch_template = true

  tags = {
    Name = "ami-cj2pce"
  }
}
resource "aws_ami" "comp3_ami-yqc74j" {
  used_in_launch_template = true

  tags = {
    Name = "ami-yqc74j"
  }
}
resource "aws_ami" "comp3_ami-m5xvob" {
  used_in_launch_template = true

  tags = {
    Name = "ami-m5xvob"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 4/18 · seeded from L1-010
# ═══════════════════════════════════════════════════════════════

resource "aws_dynamodb_table" "comp4_dynamodb-table-w1avyq" {
  name         = "dynamodb-table-w1avyq"
  billing_mode = "PROVISIONED"

  hash_key  = "id"

  attribute {
    name = "id"
    type = "S"
  }

  read_capacity  = 5000
  write_capacity = 1000

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "dynamodb-table-w1avyq"
  }
}

resource "aws_dynamodb_table" "comp4_dynamodb-table-rgcxpp" {
  name         = "dynamodb-table-rgcxpp"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "dynamodb-table-rgcxpp"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 5/18 · seeded from L1-011
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp5_s3-bucket-0ce6f0" {
  bucket = "data-lake-raw"

  tags = {
    Name        = "data-lake-raw"
  }
}

resource "aws_s3_bucket" "comp5_s3-bucket-8zghsn" {
  bucket = "data-lake-archive"

  tags = {
    Name        = "data-lake-archive"
  }
}

resource "aws_s3_bucket" "comp5_s3-bucket-agzzed" {
  bucket = "data-lake-curated"

  tags = {
    Name        = "data-lake-curated"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "comp5_s3-bucket-agzzed" {
  bucket = aws_s3_bucket.comp5_s3-bucket-agzzed.id

  rule {
    id     = "transition-rule"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

  }

}

# ═══════════════════════════════════════════════════════════════
# Component 6/18 · seeded from L1-013
# ═══════════════════════════════════════════════════════════════

resource "aws_db_instance" "comp6_db-instance-b6vpkj" {
  identifier     = "db-instance-b6vpkj"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 35

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-b6vpkj"
  }
}

resource "aws_db_instance" "comp6_db-instance-4n7qee" {
  identifier     = "db-instance-4n7qee"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 35

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-4n7qee"
  }
}

resource "aws_db_instance" "comp6_db-instance-f030k6" {
  identifier     = "db-instance-f030k6"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 200
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-f030k6"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 7/18 · seeded from L2-014
# ═══════════════════════════════════════════════════════════════

resource "aws_lambda_function" "comp7_lambda-function-59xmtq" {
  function_name = "lambda-function-59xmtq"
  role          = aws_iam_role.lambda-function-59xmtq_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 3008
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-59xmtq"
  }
}

resource "aws_lambda_function" "comp7_lambda-function-m2ut65" {
  function_name = "lambda-function-m2ut65"
  role          = aws_iam_role.lambda-function-m2ut65_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 3008
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-m2ut65"
  }
}

resource "aws_lambda_function" "comp7_lambda-function-inspfl" {
  function_name = "lambda-function-inspfl"
  role          = aws_iam_role.lambda-function-inspfl_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 3008
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-inspfl"
  }
}

resource "aws_lambda_function" "comp7_lambda-function-y8ewq1" {
  function_name = "lambda-function-y8ewq1"
  role          = aws_iam_role.lambda-function-y8ewq1_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 512
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-y8ewq1"
  }
}

resource "aws_lambda_function" "comp7_lambda-function-4624zc" {
  function_name = "lambda-function-4624zc"
  role          = aws_iam_role.lambda-function-4624zc_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  memory_size = 512
  timeout     = 30

  environment {
    variables = {
      ENVIRONMENT = "production"
    }
  }

  tags = {
    Name = "lambda-function-4624zc"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 8/18 · seeded from L2-018
# ═══════════════════════════════════════════════════════════════

resource "aws_kinesis_stream" "comp8_kinesis-stream-sngzil" {
  shard_count = 100
  stream_mode = "PROVISIONED"
  retention_hours = 24

  tags = {
    Name = "kinesis-stream-sngzil"
  }
}
resource "aws_kinesis_stream" "comp8_kinesis-stream-wtrka2" {
  shard_count = 4
  stream_mode = "ON_DEMAND"
  retention_hours = 24

  tags = {
    Name = "kinesis-stream-wtrka2"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 9/18 · seeded from L2-019
# ═══════════════════════════════════════════════════════════════

resource "aws_elasticache_replication_group" "comp9_elasticache-replication-group-f9l8ks" {
  replication_group_id = "elasticache-replication-group-f9l8ks"
  description          = "Redis replication group"

  node_type            = "cache.r5.large"
  num_cache_clusters   = 6
  engine               = "redis"
  engine_version       = "7.0"

  automatic_failover_enabled = true

  port = 6379

  subnet_group_name  = aws_elasticache_subnet_group.comp9_elasticache-replication-group-f9l8ks.name
  security_group_ids = [aws_security_group.elasticache-replication-group-f9l8ks_sg.id]

  tags = {
    Name = "elasticache-replication-group-f9l8ks"
  }
}

resource "aws_elasticache_subnet_group" "comp9_elasticache-replication-group-f9l8ks" {
  name       = "elasticache-replication-group-f9l8ks-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_replication_group" "comp9_elasticache-replication-group-ftndwq" {
  replication_group_id = "elasticache-replication-group-ftndwq"
  description          = "Redis replication group"

  node_type            = "cache.r5.large"
  num_cache_clusters   = 2
  engine               = "redis"
  engine_version       = "7.0"

  automatic_failover_enabled = true

  port = 6379

  subnet_group_name  = aws_elasticache_subnet_group.comp9_elasticache-replication-group-ftndwq.name
  security_group_ids = [aws_security_group.elasticache-replication-group-ftndwq_sg.id]

  tags = {
    Name = "elasticache-replication-group-ftndwq"
  }
}

resource "aws_elasticache_subnet_group" "comp9_elasticache-replication-group-ftndwq" {
  name       = "elasticache-replication-group-ftndwq-subnet-group"
  subnet_ids = var.private_subnet_ids
}

# ═══════════════════════════════════════════════════════════════
# Component 10/18 · seeded from L2-020
# ═══════════════════════════════════════════════════════════════

resource "aws_db_instance" "comp10_db-instance-ko7zhy" {
  identifier     = "db-instance-ko7zhy"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  replicate_source_db = aws_db_instance.primary.identifier

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-ko7zhy"
    Role        = "read_replica"
  }
}

resource "aws_db_instance" "comp10_db-instance-y0y4ty" {
  identifier     = "db-instance-y0y4ty"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  replicate_source_db = aws_db_instance.primary.identifier

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-y0y4ty"
    Role        = "read_replica"
  }
}

resource "aws_db_instance" "comp10_db-instance-825sha" {
  identifier     = "db-instance-825sha"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = false

  replicate_source_db = aws_db_instance.primary.identifier

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-825sha"
    Role        = "read_replica"
  }
}

resource "aws_db_instance" "comp10_db-instance-me542z" {
  identifier     = "db-instance-me542z"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"

  multi_az = true

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-me542z"
    Role        = "primary"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 11/18 · seeded from L2-022
# ═══════════════════════════════════════════════════════════════

resource "aws_kinesis_stream" "comp11_kinesis-stream-tuxbgq" {
  shard_count = 20
  retention_period_hours = 24
  enhanced_fan_out = true
  processing_interval_minutes = 5

  tags = {
    Name = "kinesis-stream-tuxbgq"
  }
}
resource "aws_kinesis_stream_consumer" "comp11_kinesis-stream-consumer-0tb02p" {
  consumer_type = "enhanced_fan_out"
  data_read_gb_per_day = 250

  tags = {
    Name = "kinesis-stream-consumer-0tb02p"
  }
}
resource "aws_kinesis_stream_consumer" "comp11_kinesis-stream-consumer-19xuyi" {
  consumer_type = "enhanced_fan_out"
  data_read_gb_per_day = 250

  tags = {
    Name = "kinesis-stream-consumer-19xuyi"
  }
}
resource "aws_kinesis_stream" "comp11_kinesis-stream-g4ns59" {
  shard_count = 5
  retention_period_hours = 24
  enhanced_fan_out = false
  processing_interval_minutes = 1

  tags = {
    Name = "kinesis-stream-g4ns59"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 12/18 · seeded from L3-025
# ═══════════════════════════════════════════════════════════════

resource "aws_nat_gateway" "comp12_nat-gateway-mku6w3" {
  allocation_id = aws_eip.comp12_nat-gateway-mku6w3_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-mku6w3"
  }
}

resource "aws_eip" "comp12_nat-gateway-mku6w3_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-mku6w3-eip"
  }
}

resource "aws_subnet" "comp12_subnet-ikrcp5_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-ikrcp5-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-ikrcp5_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-ikrcp5-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-ikrcp5_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-ikrcp5-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_subnet" "comp12_subnet-76b1yq_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-76b1yq-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-76b1yq_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-76b1yq-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-76b1yq_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-76b1yq-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_subnet" "comp12_subnet-o4fart_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-o4fart-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-o4fart_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-o4fart-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-o4fart_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-o4fart-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_route_table" "comp12_route-table-ovmmg8" {
  associated_subnets = "all_private"

  tags = {
    Name = "route-table-ovmmg8"
  }
}
resource "aws_route_table" "comp12_route-table-ei1zoq" {
  associated_subnets = "all_private"

  tags = {
    Name = "route-table-ei1zoq"
  }
}
resource "aws_route_table" "comp12_route-table-n4u754" {
  associated_subnets = "all_private"

  tags = {
    Name = "route-table-n4u754"
  }
}
resource "aws_nat_gateway" "comp12_nat-gateway-qfv5lz" {
  allocation_id = aws_eip.comp12_nat-gateway-qfv5lz_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-qfv5lz"
  }
}

resource "aws_eip" "comp12_nat-gateway-qfv5lz_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-qfv5lz-eip"
  }
}

resource "aws_nat_gateway" "comp12_nat-gateway-j7x4s0" {
  allocation_id = aws_eip.comp12_nat-gateway-j7x4s0_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-j7x4s0"
  }
}

resource "aws_eip" "comp12_nat-gateway-j7x4s0_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-j7x4s0-eip"
  }
}

resource "aws_nat_gateway" "comp12_nat-gateway-xk4no7" {
  allocation_id = aws_eip.comp12_nat-gateway-xk4no7_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-xk4no7"
  }
}

resource "aws_eip" "comp12_nat-gateway-xk4no7_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-xk4no7-eip"
  }
}

resource "aws_subnet" "comp12_subnet-mw1is5_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-mw1is5-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-mw1is5_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-mw1is5-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-mw1is5_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-mw1is5-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_subnet" "comp12_subnet-cjnajx_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-cjnajx-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-cjnajx_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-cjnajx-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-cjnajx_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-cjnajx-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_subnet" "comp12_subnet-1xfrmi_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-1xfrmi-ap-northeast-2a"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-1xfrmi_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-1xfrmi-ap-northeast-2b"
    Type = "private"
  }
}
resource "aws_subnet" "comp12_subnet-1xfrmi_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "ap-northeast-2c"

  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-1xfrmi-ap-northeast-2c"
    Type = "private"
  }
}

resource "aws_route_table" "comp12_route-table-ogl9uc" {
  associated_subnets = "same_az_private"

  tags = {
    Name = "route-table-ogl9uc"
  }
}
resource "aws_route_table" "comp12_route-table-6k8oe5" {
  associated_subnets = "same_az_private"

  tags = {
    Name = "route-table-6k8oe5"
  }
}
resource "aws_route_table" "comp12_route-table-2k1tb5" {
  associated_subnets = "same_az_private"

  tags = {
    Name = "route-table-2k1tb5"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 13/18 · seeded from L3-029
# ═══════════════════════════════════════════════════════════════

resource "aws_instance" "comp13_instance-lq6549" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-lq6549"
  }
}

resource "aws_instance" "comp13_instance-eebtrd" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-eebtrd"
  }
}

resource "aws_instance" "comp13_instance-4b4wya" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-4b4wya"
  }
}

resource "aws_instance" "comp13_instance-yhglra" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-yhglra"
  }
}

resource "aws_instance" "comp13_instance-k42flw" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-k42flw"
  }
}

resource "aws_nat_gateway" "comp13_nat-gateway-9mv5yz" {
  allocation_id = aws_eip.comp13_nat-gateway-9mv5yz_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "nat-gateway-9mv5yz"
  }
}

resource "aws_eip" "comp13_nat-gateway-9mv5yz_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-9mv5yz-eip"
  }
}

resource "aws_instance" "comp13_instance-1rhl9m" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-1rhl9m"
  }
}

resource "aws_instance" "comp13_instance-9n6juk" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-9n6juk"
  }
}

resource "aws_vpc_endpoint" "comp13_vpc-endpoint-lix61i" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = {
    Name = "vpc-endpoint-lix61i"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 14/18 · seeded from L3-031
# ═══════════════════════════════════════════════════════════════

resource "aws_instance" "comp14_instance-hqxpi5" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-hqxpi5"
  }
}

resource "aws_instance" "comp14_instance-tqzltl" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-tqzltl"
  }
}

resource "aws_instance" "comp14_instance-9u8vjr" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-9u8vjr"
  }
}

resource "aws_instance" "comp14_instance-uafacq" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-uafacq"
  }
}

resource "aws_instance" "comp14_instance-hrzaoc" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-hrzaoc"
  }
}

resource "aws_instance" "comp14_instance-7pjemw" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-7pjemw"
  }
}

resource "aws_instance" "comp14_instance-ze661r" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "c5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-ze661r"
    environment = "production"
  }
}

resource "aws_instance" "comp14_instance-rky2by" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "c5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-rky2by"
    environment = "production"
  }
}

resource "aws_instance" "comp14_instance-2as674" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "c5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-2as674"
    environment = "production"
  }
}

resource "aws_instance" "comp14_instance-0fo36p" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "c5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-0fo36p"
    environment = "production"
  }
}

resource "aws_db_instance" "comp14_db-instance-4nlgs2" {
  identifier     = "db-instance-4nlgs2"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-4nlgs2"
  }
}

resource "aws_db_instance" "comp14_db-instance-ntzubf" {
  identifier     = "db-instance-ntzubf"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-ntzubf"
  }
}

resource "aws_db_instance" "comp14_db-instance-f0i8og" {
  identifier     = "db-instance-f0i8og"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-f0i8og"
  }
}

resource "aws_s3_bucket" "comp14_s3-bucket-0qxn06" {
  bucket = "s3-bucket-0qxn06"

  tags = {
    Name        = "s3-bucket-0qxn06"
  }
}

resource "aws_s3_bucket" "comp14_s3-bucket-pn3ncl" {
  bucket = "s3-bucket-pn3ncl"

  tags = {
    Name        = "s3-bucket-pn3ncl"
  }
}

resource "aws_s3_bucket" "comp14_s3-bucket-hk5zbu" {
  bucket = "s3-bucket-hk5zbu"

  tags = {
    Name        = "s3-bucket-hk5zbu"
  }
}

resource "aws_s3_bucket" "comp14_s3-bucket-peafuh" {
  bucket = "s3-bucket-peafuh"

  tags = {
    Name        = "s3-bucket-peafuh"
  }
}

resource "aws_lb" "comp14_lb-oq2c2r" {
  name               = "lb-oq2c2r"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-oq2c2r_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-oq2c2r"
    team = "platform"
  }
}

resource "aws_lb" "comp14_lb-3835yr" {
  name               = "lb-3835yr"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-3835yr_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-3835yr"
    team = "platform"
  }
}

resource "aws_lb" "comp14_lb-zb2cev" {
  name               = "lb-zb2cev"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-zb2cev_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Name = "lb-zb2cev"
    team = "platform"
  }
}

resource "aws_instance" "comp14_instance-s75j34" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-s75j34"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_instance" "comp14_instance-cazrp1" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-cazrp1"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_instance" "comp14_instance-yy08oy" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-yy08oy"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_instance" "comp14_instance-4jpj1x" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.large"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-4jpj1x"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_db_instance" "comp14_db-instance-by6lt3" {
  identifier     = "db-instance-by6lt3"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-by6lt3"
    cost-center = "CC-1002"
    team = "data"
    environment = "production"
    project = "analytics"
  }
}

resource "aws_db_instance" "comp14_db-instance-f5upl6" {
  identifier     = "db-instance-f5upl6"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-f5upl6"
    cost-center = "CC-1002"
    team = "data"
    environment = "production"
    project = "analytics"
  }
}

resource "aws_db_instance" "comp14_db-instance-a2vzse" {
  identifier     = "db-instance-a2vzse"
  engine         = "postgres"
  engine_version = "8.0"
  instance_class = "db.r5.large"

  allocated_storage = 100
  storage_type      = "gp3"

  multi_az = false

  backup_retention_period = 7

  skip_final_snapshot = false

  tags = {
    Name        = "db-instance-a2vzse"
    cost-center = "CC-1002"
    team = "data"
    environment = "production"
    project = "analytics"
  }
}

resource "aws_s3_bucket" "comp14_s3-bucket-mwdcj3" {
  bucket = "s3-bucket-mwdcj3"

  tags = {
    Name        = "s3-bucket-mwdcj3"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_s3_bucket" "comp14_s3-bucket-j04k0w" {
  bucket = "s3-bucket-j04k0w"

  tags = {
    Name        = "s3-bucket-j04k0w"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

resource "aws_s3_bucket" "comp14_s3-bucket-mbvkck" {
  bucket = "s3-bucket-mbvkck"

  tags = {
    Name        = "s3-bucket-mbvkck"
    cost-center = "CC-1001"
    team = "backend"
    environment = "production"
    project = "api-gateway"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 15/18 · seeded from L3-035
# ═══════════════════════════════════════════════════════════════

resource "aws_glue_catalog_table" "comp15_glue-catalog-table-8v31za" {
  database_name = "analytics_db"
  table_name = "raw_events"
  storage_location = "s3://data-lake-prod/raw_events/"
  total_data_size_tb = 10
  format = "parquet"

  tags = {
    Name = "glue-catalog-table-8v31za"
  }
}
resource "aws_s3_bucket" "comp15_s3-bucket-voxygj" {
  bucket = "data-lake-prod"

  tags = {
    Name        = "data-lake-prod"
  }
}

resource "aws_glue_catalog_table" "comp15_glue-catalog-table-31slaj" {
  database_name = "analytics_db"
  table_name = "processed_events"
  storage_location = "s3://data-lake-prod/processed_events/"
  total_data_size_tb = 8
  format = "parquet"

  tags = {
    Name = "glue-catalog-table-31slaj"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 16/18 · seeded from L3-036
# ═══════════════════════════════════════════════════════════════

resource "aws_redshift_cluster" "comp16_redshift-cluster-ezbaz2" {
  cluster_identifier = "analytics-prod"
  database_name      = "analytics"
  master_username    = "admin"
  master_password    = var.redshift_master_password
  node_type          = "ra3.xlplus"
  number_of_nodes    = 4

  encrypted = true

  skip_final_snapshot = false

  tags = {
    Name     = "redshift-cluster-ezbaz2"
    Schedule = "always-on"
  }
}

resource "aws_redshift_cluster" "comp16_redshift-cluster-wbwv2x" {
  cluster_identifier = "analytics-scheduled"
  database_name      = "analytics"
  master_username    = "admin"
  master_password    = var.redshift_master_password
  node_type          = "ra3.xlplus"
  number_of_nodes    = 4

  encrypted = true

  skip_final_snapshot = false

  tags = {
    Name     = "redshift-cluster-wbwv2x"
    Schedule = "paused-nights-weekends"
  }
}

# Redshift scheduled actions for pause/resume
resource "aws_redshift_scheduled_action" "comp16_redshift-cluster-wbwv2x_pause" {
  name     = "redshift-cluster-wbwv2x-pause"
  schedule = "cron(0 18 ? * MON-FRI *)"
  iam_role = aws_iam_role.redshift-cluster-wbwv2x_scheduler_role.arn

  target_action {
    pause_cluster {
      cluster_identifier = aws_redshift_cluster.comp16_redshift-cluster-wbwv2x.cluster_identifier
    }
  }
}

resource "aws_redshift_scheduled_action" "comp16_redshift-cluster-wbwv2x_resume" {
  name     = "redshift-cluster-wbwv2x-resume"
  schedule = "cron(0 9 ? * MON-FRI *)"
  iam_role = aws_iam_role.redshift-cluster-wbwv2x_scheduler_role.arn

  target_action {
    resume_cluster {
      cluster_identifier = aws_redshift_cluster.comp16_redshift-cluster-wbwv2x.cluster_identifier
    }
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 17/18 · seeded from L3-038
# ═══════════════════════════════════════════════════════════════

resource "aws_eks_cluster" "comp17_eks-cluster-8h7nr7" {
  name     = "prod-main"
  role_arn = aws_iam_role.eks-cluster-8h7nr7_cluster_role.arn
  version  = "1.28"

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = {
    Name = "eks-cluster-8h7nr7"
  }
}

resource "aws_instance" "comp17_instance-cijnwl" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-cijnwl"
  }
}

resource "aws_instance" "comp17_instance-ppqkm7" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-ppqkm7"
  }
}

resource "aws_instance" "comp17_instance-x5j45t" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-x5j45t"
  }
}

resource "aws_instance" "comp17_instance-fwiz42" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-fwiz42"
  }
}

resource "aws_instance" "comp17_instance-0axizo" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-0axizo"
  }
}

resource "aws_instance" "comp17_instance-j1lfox" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-j1lfox"
  }
}

resource "aws_instance" "comp17_instance-vb5eh8" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-vb5eh8"
  }
}

resource "aws_instance" "comp17_instance-8cs9ao" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-8cs9ao"
  }
}

resource "aws_instance" "comp17_instance-rl6uvm" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-rl6uvm"
  }
}

resource "aws_instance" "comp17_instance-fbel5p" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-fbel5p"
  }
}

resource "aws_instance" "comp17_instance-5ogkc5" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-5ogkc5"
  }
}

resource "aws_instance" "comp17_instance-3m6v6s" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-3m6v6s"
  }
}

resource "aws_instance" "comp17_instance-kpiqq5" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-kpiqq5"
  }
}

resource "aws_instance" "comp17_instance-ka85lp" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-ka85lp"
  }
}

resource "aws_instance" "comp17_instance-9frzzu" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-9frzzu"
  }
}

resource "aws_instance" "comp17_instance-wgzyfw" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-wgzyfw"
  }
}

resource "aws_instance" "comp17_instance-mmkc9k" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-mmkc9k"
  }
}

resource "aws_instance" "comp17_instance-2wng0i" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-2wng0i"
  }
}

resource "aws_instance" "comp17_instance-y8z75e" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-y8z75e"
  }
}

resource "aws_instance" "comp17_instance-aj3gxe" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.2xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-aj3gxe"
  }
}

resource "aws_instance" "comp17_instance-tdw4s4" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-tdw4s4"
  }
}

resource "aws_instance" "comp17_instance-qsihnk" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-qsihnk"
  }
}

resource "aws_instance" "comp17_instance-qjj3zl" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-qjj3zl"
  }
}

resource "aws_instance" "comp17_instance-mp5ijo" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-mp5ijo"
  }
}

resource "aws_instance" "comp17_instance-83mrqg" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-83mrqg"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 18/18 · seeded from L3-039
# ═══════════════════════════════════════════════════════════════

resource "aws_s3_bucket" "comp18_s3-bucket-5qf4hv" {
  bucket = "static-assets-prod"

  # Static website hosting enabled

  tags = {
    Name        = "static-assets-prod"
  }
}

resource "aws_cloudfront_distribution" "comp18_cloudfront-distribution-6vrtkr" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "CloudFront distribution"
  price_class     = "PriceClass_All"

  origin {
    domain_name = "media-assets-prod.s3.amazonaws.com"
    origin_id   = "S3Origin"

  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "cloudfront-distribution-6vrtkr"
  }
}

resource "aws_s3_bucket" "comp18_s3-bucket-o3jtj0" {
  bucket = "media-assets-prod"

  tags = {
    Name        = "media-assets-prod"
  }
}

resource "aws_s3_bucket_public_access_block" "comp18_s3-bucket-o3jtj0" {
  bucket = aws_s3_bucket.comp18_s3-bucket-o3jtj0.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
