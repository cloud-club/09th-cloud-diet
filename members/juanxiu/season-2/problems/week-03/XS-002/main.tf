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
# Component 1/3 · seeded from L1-001
# ═══════════════════════════════════════════════════════════════

resource "aws_instance" "comp1_instance-54pv5c" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "m5.xlarge"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-54pv5c"
  }
}

resource "aws_ebs_volume" "comp1_ebs-volume-5vha05" {
  availability_zone = "ap-northeast-2a"
  size              = 500
  type              = "gp2"

  encrypted = true

  tags = {
    Name = "ebs-volume-5vha05"
    AttachedTo = "stopped_instance"
  }
}

resource "aws_ebs_volume" "comp1_ebs-volume-1l2nwn" {
  availability_zone = "ap-northeast-2a"
  size              = 500
  type              = "gp2"

  encrypted = true

  tags = {
    Name = "ebs-volume-1l2nwn"
    AttachedTo = "stopped_instance"
  }
}

resource "aws_ebs_volume" "comp1_ebs-volume-3wuedd" {
  availability_zone = "ap-northeast-2a"
  size              = 500
  type              = "gp2"

  encrypted = true

  tags = {
    Name = "ebs-volume-3wuedd"
    AttachedTo = "stopped_instance"
  }
}

resource "aws_instance" "comp1_instance-od6cgx" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-od6cgx"
  }
}

resource "aws_instance" "comp1_instance-sx7m0t" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.main.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name        = "instance-sx7m0t"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 2/3 · seeded from L1-003
# ═══════════════════════════════════════════════════════════════

resource "aws_eip" "comp2_eip-lepeol" {
  domain = "vpc"

  tags = {
    Name = "eip-lepeol"
  }
}

resource "aws_eip" "comp2_eip-1hs0w8" {
  domain = "vpc"

  tags = {
    Name = "eip-1hs0w8"
  }
}

resource "aws_eip" "comp2_eip-qt67j7" {
  domain = "vpc"

  tags = {
    Name = "eip-qt67j7"
  }
}

resource "aws_eip" "comp2_eip-3opgev" {
  domain = "vpc"

  tags = {
    Name = "eip-3opgev"
  }
}

resource "aws_eip" "comp2_eip-fccco8" {
  domain = "vpc"

  tags = {
    Name = "eip-fccco8"
  }
}

resource "aws_eip" "comp2_eip-uv9kmw" {
  domain = "vpc"

  instance = aws_instance.running_instance.id

  tags = {
    Name = "eip-uv9kmw"
  }
}

resource "aws_eip" "comp2_eip-oflcen" {
  domain = "vpc"

  instance = aws_instance.running_instance.id

  tags = {
    Name = "eip-oflcen"
  }
}

resource "aws_eip" "comp2_eip-rot4wr" {
  domain = "vpc"

  instance = aws_instance.running_instance.id

  tags = {
    Name = "eip-rot4wr"
  }
}

# ═══════════════════════════════════════════════════════════════
# Component 3/3 · seeded from L1-007
# ═══════════════════════════════════════════════════════════════

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-9deemq" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-9deemq"

  tags = {
    Name = "ebs-snapshot-9deemq"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-vg7o2b" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-vg7o2b"

  tags = {
    Name = "ebs-snapshot-vg7o2b"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-z8jjkm" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-z8jjkm"

  tags = {
    Name = "ebs-snapshot-z8jjkm"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ari86k" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ari86k"

  tags = {
    Name = "ebs-snapshot-ari86k"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-bsanwc" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-bsanwc"

  tags = {
    Name = "ebs-snapshot-bsanwc"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-gktv0h" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-gktv0h"

  tags = {
    Name = "ebs-snapshot-gktv0h"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-woelgj" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-woelgj"

  tags = {
    Name = "ebs-snapshot-woelgj"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-k6ql4o" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-k6ql4o"

  tags = {
    Name = "ebs-snapshot-k6ql4o"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-idmv1r" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-idmv1r"

  tags = {
    Name = "ebs-snapshot-idmv1r"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-juuiuh" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-juuiuh"

  tags = {
    Name = "ebs-snapshot-juuiuh"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-kasnsf" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-kasnsf"

  tags = {
    Name = "ebs-snapshot-kasnsf"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-xrsbeu" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-xrsbeu"

  tags = {
    Name = "ebs-snapshot-xrsbeu"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-bphzia" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-bphzia"

  tags = {
    Name = "ebs-snapshot-bphzia"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-o9em2j" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-o9em2j"

  tags = {
    Name = "ebs-snapshot-o9em2j"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-8rmn15" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-8rmn15"

  tags = {
    Name = "ebs-snapshot-8rmn15"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-4mfbdt" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-4mfbdt"

  tags = {
    Name = "ebs-snapshot-4mfbdt"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-g024z0" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-g024z0"

  tags = {
    Name = "ebs-snapshot-g024z0"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-mih7t2" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-mih7t2"

  tags = {
    Name = "ebs-snapshot-mih7t2"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-fgtvcf" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-fgtvcf"

  tags = {
    Name = "ebs-snapshot-fgtvcf"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-6ywu0o" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-6ywu0o"

  tags = {
    Name = "ebs-snapshot-6ywu0o"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-14dn6u" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-14dn6u"

  tags = {
    Name = "ebs-snapshot-14dn6u"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-z0gxqg" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-z0gxqg"

  tags = {
    Name = "ebs-snapshot-z0gxqg"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-30uxte" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-30uxte"

  tags = {
    Name = "ebs-snapshot-30uxte"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-u6a51r" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-u6a51r"

  tags = {
    Name = "ebs-snapshot-u6a51r"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-fbzeqz" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-fbzeqz"

  tags = {
    Name = "ebs-snapshot-fbzeqz"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-3ai5zw" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-3ai5zw"

  tags = {
    Name = "ebs-snapshot-3ai5zw"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-4p23jn" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-4p23jn"

  tags = {
    Name = "ebs-snapshot-4p23jn"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-55ejdw" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-55ejdw"

  tags = {
    Name = "ebs-snapshot-55ejdw"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-i7cuvv" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-i7cuvv"

  tags = {
    Name = "ebs-snapshot-i7cuvv"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-exmdb8" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-exmdb8"

  tags = {
    Name = "ebs-snapshot-exmdb8"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ehkzym" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ehkzym"

  tags = {
    Name = "ebs-snapshot-ehkzym"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-04jml5" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-04jml5"

  tags = {
    Name = "ebs-snapshot-04jml5"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-p931wn" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-p931wn"

  tags = {
    Name = "ebs-snapshot-p931wn"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-i9q60j" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-i9q60j"

  tags = {
    Name = "ebs-snapshot-i9q60j"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-5wnwfm" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-5wnwfm"

  tags = {
    Name = "ebs-snapshot-5wnwfm"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-kre24a" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-kre24a"

  tags = {
    Name = "ebs-snapshot-kre24a"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ifq1wi" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ifq1wi"

  tags = {
    Name = "ebs-snapshot-ifq1wi"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-r8b6x1" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-r8b6x1"

  tags = {
    Name = "ebs-snapshot-r8b6x1"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-u5yau6" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-u5yau6"

  tags = {
    Name = "ebs-snapshot-u5yau6"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-z5ik0l" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-z5ik0l"

  tags = {
    Name = "ebs-snapshot-z5ik0l"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-xfapel" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-xfapel"

  tags = {
    Name = "ebs-snapshot-xfapel"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-vo5l6q" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-vo5l6q"

  tags = {
    Name = "ebs-snapshot-vo5l6q"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-tfbnpr" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-tfbnpr"

  tags = {
    Name = "ebs-snapshot-tfbnpr"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-pgz1fs" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-pgz1fs"

  tags = {
    Name = "ebs-snapshot-pgz1fs"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-5dyib5" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-5dyib5"

  tags = {
    Name = "ebs-snapshot-5dyib5"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-bq4ihv" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-bq4ihv"

  tags = {
    Name = "ebs-snapshot-bq4ihv"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-r9j5q9" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-r9j5q9"

  tags = {
    Name = "ebs-snapshot-r9j5q9"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ai0rbo" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ai0rbo"

  tags = {
    Name = "ebs-snapshot-ai0rbo"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-8957bn" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-8957bn"

  tags = {
    Name = "ebs-snapshot-8957bn"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-nfclq7" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-nfclq7"

  tags = {
    Name = "ebs-snapshot-nfclq7"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-lfz59z" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-lfz59z"

  tags = {
    Name = "ebs-snapshot-lfz59z"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-e32u7t" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-e32u7t"

  tags = {
    Name = "ebs-snapshot-e32u7t"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-45iop3" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-45iop3"

  tags = {
    Name = "ebs-snapshot-45iop3"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ubgr16" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ubgr16"

  tags = {
    Name = "ebs-snapshot-ubgr16"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-eem8ul" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-eem8ul"

  tags = {
    Name = "ebs-snapshot-eem8ul"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-wdrelc" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-wdrelc"

  tags = {
    Name = "ebs-snapshot-wdrelc"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-781j93" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-781j93"

  tags = {
    Name = "ebs-snapshot-781j93"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-5swdig" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-5swdig"

  tags = {
    Name = "ebs-snapshot-5swdig"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-mxsqqx" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-mxsqqx"

  tags = {
    Name = "ebs-snapshot-mxsqqx"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-gdqh2b" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-gdqh2b"

  tags = {
    Name = "ebs-snapshot-gdqh2b"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-a2377t" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-a2377t"

  tags = {
    Name = "ebs-snapshot-a2377t"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-na5v9a" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-na5v9a"

  tags = {
    Name = "ebs-snapshot-na5v9a"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-qh591c" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-qh591c"

  tags = {
    Name = "ebs-snapshot-qh591c"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-tli7b0" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-tli7b0"

  tags = {
    Name = "ebs-snapshot-tli7b0"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-e9ft7z" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-e9ft7z"

  tags = {
    Name = "ebs-snapshot-e9ft7z"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-enhmpy" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-enhmpy"

  tags = {
    Name = "ebs-snapshot-enhmpy"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-y0wgft" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-y0wgft"

  tags = {
    Name = "ebs-snapshot-y0wgft"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-1oumgn" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-1oumgn"

  tags = {
    Name = "ebs-snapshot-1oumgn"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-77o2lt" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-77o2lt"

  tags = {
    Name = "ebs-snapshot-77o2lt"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ag7s9v" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ag7s9v"

  tags = {
    Name = "ebs-snapshot-ag7s9v"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-5gfm5r" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-5gfm5r"

  tags = {
    Name = "ebs-snapshot-5gfm5r"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-eqj0f3" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-eqj0f3"

  tags = {
    Name = "ebs-snapshot-eqj0f3"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-kcgp4e" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-kcgp4e"

  tags = {
    Name = "ebs-snapshot-kcgp4e"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-b83dya" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-b83dya"

  tags = {
    Name = "ebs-snapshot-b83dya"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-r3tjee" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-r3tjee"

  tags = {
    Name = "ebs-snapshot-r3tjee"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-kb95px" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-kb95px"

  tags = {
    Name = "ebs-snapshot-kb95px"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-qzfp4h" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-qzfp4h"

  tags = {
    Name = "ebs-snapshot-qzfp4h"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-9xankk" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-9xankk"

  tags = {
    Name = "ebs-snapshot-9xankk"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ljyahq" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ljyahq"

  tags = {
    Name = "ebs-snapshot-ljyahq"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-odvw16" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-odvw16"

  tags = {
    Name = "ebs-snapshot-odvw16"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ndmw4f" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ndmw4f"

  tags = {
    Name = "ebs-snapshot-ndmw4f"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-xtnoo3" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-xtnoo3"

  tags = {
    Name = "ebs-snapshot-xtnoo3"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-wjwg2q" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-wjwg2q"

  tags = {
    Name = "ebs-snapshot-wjwg2q"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-4e9h87" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-4e9h87"

  tags = {
    Name = "ebs-snapshot-4e9h87"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-y9ifqt" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-y9ifqt"

  tags = {
    Name = "ebs-snapshot-y9ifqt"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-qtr3r9" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-qtr3r9"

  tags = {
    Name = "ebs-snapshot-qtr3r9"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-uy547d" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-uy547d"

  tags = {
    Name = "ebs-snapshot-uy547d"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-nzlalu" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-nzlalu"

  tags = {
    Name = "ebs-snapshot-nzlalu"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ivi1iy" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ivi1iy"

  tags = {
    Name = "ebs-snapshot-ivi1iy"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-lp1htd" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-lp1htd"

  tags = {
    Name = "ebs-snapshot-lp1htd"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-33po98" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-33po98"

  tags = {
    Name = "ebs-snapshot-33po98"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-m2mgth" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-m2mgth"

  tags = {
    Name = "ebs-snapshot-m2mgth"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-jq93dk" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-jq93dk"

  tags = {
    Name = "ebs-snapshot-jq93dk"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-r2kdjm" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-r2kdjm"

  tags = {
    Name = "ebs-snapshot-r2kdjm"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-hn2pl8" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-hn2pl8"

  tags = {
    Name = "ebs-snapshot-hn2pl8"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-0w7r81" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-0w7r81"

  tags = {
    Name = "ebs-snapshot-0w7r81"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-og0z2o" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-og0z2o"

  tags = {
    Name = "ebs-snapshot-og0z2o"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-endev4" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-endev4"

  tags = {
    Name = "ebs-snapshot-endev4"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-u40any" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-u40any"

  tags = {
    Name = "ebs-snapshot-u40any"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-0c07zw" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-0c07zw"

  tags = {
    Name = "ebs-snapshot-0c07zw"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ylhu4x" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ylhu4x"

  tags = {
    Name = "ebs-snapshot-ylhu4x"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-abtfqh" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-abtfqh"

  tags = {
    Name = "ebs-snapshot-abtfqh"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-0eoh7u" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-0eoh7u"

  tags = {
    Name = "ebs-snapshot-0eoh7u"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-xyqldr" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-xyqldr"

  tags = {
    Name = "ebs-snapshot-xyqldr"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-be7f3s" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-be7f3s"

  tags = {
    Name = "ebs-snapshot-be7f3s"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-3zfez3" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-3zfez3"

  tags = {
    Name = "ebs-snapshot-3zfez3"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-mzc0b5" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-mzc0b5"

  tags = {
    Name = "ebs-snapshot-mzc0b5"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-nbgnh8" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-nbgnh8"

  tags = {
    Name = "ebs-snapshot-nbgnh8"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-xtxtsy" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-xtxtsy"

  tags = {
    Name = "ebs-snapshot-xtxtsy"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-j4gpch" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-j4gpch"

  tags = {
    Name = "ebs-snapshot-j4gpch"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-bfwxii" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-bfwxii"

  tags = {
    Name = "ebs-snapshot-bfwxii"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-snishq" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-snishq"

  tags = {
    Name = "ebs-snapshot-snishq"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-7lvu6q" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-7lvu6q"

  tags = {
    Name = "ebs-snapshot-7lvu6q"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-hvbfe3" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-hvbfe3"

  tags = {
    Name = "ebs-snapshot-hvbfe3"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-dm7ulc" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-dm7ulc"

  tags = {
    Name = "ebs-snapshot-dm7ulc"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-x009a7" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-x009a7"

  tags = {
    Name = "ebs-snapshot-x009a7"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-iqiftj" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-iqiftj"

  tags = {
    Name = "ebs-snapshot-iqiftj"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-xlwr77" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-xlwr77"

  tags = {
    Name = "ebs-snapshot-xlwr77"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-8bq91y" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-8bq91y"

  tags = {
    Name = "ebs-snapshot-8bq91y"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-h8688g" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-h8688g"

  tags = {
    Name = "ebs-snapshot-h8688g"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-s32p59" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-s32p59"

  tags = {
    Name = "ebs-snapshot-s32p59"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-hiqksh" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-hiqksh"

  tags = {
    Name = "ebs-snapshot-hiqksh"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-c7jao5" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-c7jao5"

  tags = {
    Name = "ebs-snapshot-c7jao5"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-y3i67r" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-y3i67r"

  tags = {
    Name = "ebs-snapshot-y3i67r"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-l4mqm7" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-l4mqm7"

  tags = {
    Name = "ebs-snapshot-l4mqm7"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-e4a3pj" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-e4a3pj"

  tags = {
    Name = "ebs-snapshot-e4a3pj"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-4wrob8" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-4wrob8"

  tags = {
    Name = "ebs-snapshot-4wrob8"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-4jqf3a" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-4jqf3a"

  tags = {
    Name = "ebs-snapshot-4jqf3a"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-qdjlit" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-qdjlit"

  tags = {
    Name = "ebs-snapshot-qdjlit"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-3u0l1r" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-3u0l1r"

  tags = {
    Name = "ebs-snapshot-3u0l1r"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-lrcbv2" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-lrcbv2"

  tags = {
    Name = "ebs-snapshot-lrcbv2"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-376bek" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-376bek"

  tags = {
    Name = "ebs-snapshot-376bek"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-d64h26" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-d64h26"

  tags = {
    Name = "ebs-snapshot-d64h26"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-h031hr" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-h031hr"

  tags = {
    Name = "ebs-snapshot-h031hr"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ek5ag0" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ek5ag0"

  tags = {
    Name = "ebs-snapshot-ek5ag0"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-rvqaln" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-rvqaln"

  tags = {
    Name = "ebs-snapshot-rvqaln"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-d9ripo" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-d9ripo"

  tags = {
    Name = "ebs-snapshot-d9ripo"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-hl71js" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-hl71js"

  tags = {
    Name = "ebs-snapshot-hl71js"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-3kgri0" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-3kgri0"

  tags = {
    Name = "ebs-snapshot-3kgri0"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-qmty39" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-qmty39"

  tags = {
    Name = "ebs-snapshot-qmty39"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-1s9q9i" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-1s9q9i"

  tags = {
    Name = "ebs-snapshot-1s9q9i"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-xvys21" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-xvys21"

  tags = {
    Name = "ebs-snapshot-xvys21"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-7xw0fx" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-7xw0fx"

  tags = {
    Name = "ebs-snapshot-7xw0fx"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-539zk9" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-539zk9"

  tags = {
    Name = "ebs-snapshot-539zk9"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-kmvbkz" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-kmvbkz"

  tags = {
    Name = "ebs-snapshot-kmvbkz"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-aoaubj" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-aoaubj"

  tags = {
    Name = "ebs-snapshot-aoaubj"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-gbqwtn" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-gbqwtn"

  tags = {
    Name = "ebs-snapshot-gbqwtn"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-6i5414" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-6i5414"

  tags = {
    Name = "ebs-snapshot-6i5414"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-jfg2cm" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-jfg2cm"

  tags = {
    Name = "ebs-snapshot-jfg2cm"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-xf2vyu" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-xf2vyu"

  tags = {
    Name = "ebs-snapshot-xf2vyu"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-vfbpcq" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-vfbpcq"

  tags = {
    Name = "ebs-snapshot-vfbpcq"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-0t2j4u" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-0t2j4u"

  tags = {
    Name = "ebs-snapshot-0t2j4u"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-sw6clk" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-sw6clk"

  tags = {
    Name = "ebs-snapshot-sw6clk"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-0ixvw1" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-0ixvw1"

  tags = {
    Name = "ebs-snapshot-0ixvw1"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-nkbys2" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-nkbys2"

  tags = {
    Name = "ebs-snapshot-nkbys2"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-99qa6a" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-99qa6a"

  tags = {
    Name = "ebs-snapshot-99qa6a"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-grfk4w" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-grfk4w"

  tags = {
    Name = "ebs-snapshot-grfk4w"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-zpbzjp" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-zpbzjp"

  tags = {
    Name = "ebs-snapshot-zpbzjp"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-kau1yu" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-kau1yu"

  tags = {
    Name = "ebs-snapshot-kau1yu"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-raicvj" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-raicvj"

  tags = {
    Name = "ebs-snapshot-raicvj"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-wr05gh" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-wr05gh"

  tags = {
    Name = "ebs-snapshot-wr05gh"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-bdz37o" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-bdz37o"

  tags = {
    Name = "ebs-snapshot-bdz37o"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-5qosxu" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-5qosxu"

  tags = {
    Name = "ebs-snapshot-5qosxu"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-gfs6qw" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-gfs6qw"

  tags = {
    Name = "ebs-snapshot-gfs6qw"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-83r8wu" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-83r8wu"

  tags = {
    Name = "ebs-snapshot-83r8wu"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-t4exhd" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-t4exhd"

  tags = {
    Name = "ebs-snapshot-t4exhd"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-70b1tq" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-70b1tq"

  tags = {
    Name = "ebs-snapshot-70b1tq"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-z5mbjw" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-z5mbjw"

  tags = {
    Name = "ebs-snapshot-z5mbjw"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-5ocunw" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-5ocunw"

  tags = {
    Name = "ebs-snapshot-5ocunw"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-q6q4qq" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-q6q4qq"

  tags = {
    Name = "ebs-snapshot-q6q4qq"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-hlhyvc" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-hlhyvc"

  tags = {
    Name = "ebs-snapshot-hlhyvc"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-igm7k7" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-igm7k7"

  tags = {
    Name = "ebs-snapshot-igm7k7"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ko4e77" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ko4e77"

  tags = {
    Name = "ebs-snapshot-ko4e77"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-9v19a8" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-9v19a8"

  tags = {
    Name = "ebs-snapshot-9v19a8"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ai7te5" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ai7te5"

  tags = {
    Name = "ebs-snapshot-ai7te5"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-cs33bw" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-cs33bw"

  tags = {
    Name = "ebs-snapshot-cs33bw"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-yvthjc" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-yvthjc"

  tags = {
    Name = "ebs-snapshot-yvthjc"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-u4nuet" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-u4nuet"

  tags = {
    Name = "ebs-snapshot-u4nuet"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-hdzm90" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-hdzm90"

  tags = {
    Name = "ebs-snapshot-hdzm90"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ufpdoa" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ufpdoa"

  tags = {
    Name = "ebs-snapshot-ufpdoa"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-cmvti2" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-cmvti2"

  tags = {
    Name = "ebs-snapshot-cmvti2"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-w1z88a" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-w1z88a"

  tags = {
    Name = "ebs-snapshot-w1z88a"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-jg9d3u" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-jg9d3u"

  tags = {
    Name = "ebs-snapshot-jg9d3u"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-cqkurh" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-cqkurh"

  tags = {
    Name = "ebs-snapshot-cqkurh"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-wly88g" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-wly88g"

  tags = {
    Name = "ebs-snapshot-wly88g"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-rsgmdp" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-rsgmdp"

  tags = {
    Name = "ebs-snapshot-rsgmdp"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-7c8iz5" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-7c8iz5"

  tags = {
    Name = "ebs-snapshot-7c8iz5"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-q1bmwd" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-q1bmwd"

  tags = {
    Name = "ebs-snapshot-q1bmwd"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-kqrbfp" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-kqrbfp"

  tags = {
    Name = "ebs-snapshot-kqrbfp"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-zjt7kn" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-zjt7kn"

  tags = {
    Name = "ebs-snapshot-zjt7kn"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-chl0g5" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-chl0g5"

  tags = {
    Name = "ebs-snapshot-chl0g5"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-un9ny8" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-un9ny8"

  tags = {
    Name = "ebs-snapshot-un9ny8"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-oswsy7" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-oswsy7"

  tags = {
    Name = "ebs-snapshot-oswsy7"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-dlcsly" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-dlcsly"

  tags = {
    Name = "ebs-snapshot-dlcsly"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-fvsny1" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-fvsny1"

  tags = {
    Name = "ebs-snapshot-fvsny1"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-p82eyi" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-p82eyi"

  tags = {
    Name = "ebs-snapshot-p82eyi"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-nacejm" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-nacejm"

  tags = {
    Name = "ebs-snapshot-nacejm"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-8r705j" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-8r705j"

  tags = {
    Name = "ebs-snapshot-8r705j"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-3rwdwp" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-3rwdwp"

  tags = {
    Name = "ebs-snapshot-3rwdwp"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-81b30q" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-81b30q"

  tags = {
    Name = "ebs-snapshot-81b30q"
    SourceVolumeStatus = "deleted"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-8ffvjg" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-8ffvjg"

  tags = {
    Name = "ebs-snapshot-8ffvjg"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-1r7r2z" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-1r7r2z"

  tags = {
    Name = "ebs-snapshot-1r7r2z"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-uc60is" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-uc60is"

  tags = {
    Name = "ebs-snapshot-uc60is"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-sihv5h" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-sihv5h"

  tags = {
    Name = "ebs-snapshot-sihv5h"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-qdnv6z" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-qdnv6z"

  tags = {
    Name = "ebs-snapshot-qdnv6z"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-94jos2" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-94jos2"

  tags = {
    Name = "ebs-snapshot-94jos2"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ysqgsm" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ysqgsm"

  tags = {
    Name = "ebs-snapshot-ysqgsm"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-2o6akz" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-2o6akz"

  tags = {
    Name = "ebs-snapshot-2o6akz"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-s64ty6" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-s64ty6"

  tags = {
    Name = "ebs-snapshot-s64ty6"
    SourceVolumeStatus = "exists"
  }
}

resource "aws_ebs_snapshot" "comp3_ebs-snapshot-ny9qnq" {
  volume_id   = "vol-placeholder"
  description = "Snapshot ebs-snapshot-ny9qnq"

  tags = {
    Name = "ebs-snapshot-ny9qnq"
    SourceVolumeStatus = "exists"
  }
}
