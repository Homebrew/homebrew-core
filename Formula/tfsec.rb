class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.40.7.tar.gz"
  sha256 "26fc1066da8bd926f0b72890162dcf67bf4417ed51edbc4922e97ced9e6d588f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9093c1a67c3bbc5c486e55af3676e7b512fbab9edc1e6b7547a841f279834af"
    sha256 cellar: :any_skip_relocation, big_sur:       "34c02c28b9eb54462e622c341b7f5512bd7c7a30980f75ec1d03282e2abcbb85"
    sha256 cellar: :any_skip_relocation, catalina:      "fd6ea74bf42d75692d6057574564c319364b55ed65eae1e342b08d8dbd3593ce"
    sha256 cellar: :any_skip_relocation, mojave:        "17d25e81d563745779b597bdf9b4e001154ad74240538c9e102a1868e0dac552"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "WARNING", bad_output
  end
end
