class Sesmate < Formula
  desc "Friendly AWS SES assistant, to better maintain SES templates in your project"
  homepage "https://github.com/BlackHole1/sesmate"
  url "https://github.com/BlackHole1/sesmate/archive/v1.1.0.tar.gz"
  sha256 "a93aa06283c3792724944dc3142170ea2a27d2b6273de6df052c5f499f05a6c6"
  license "MIT"
  head "https://github.com/BlackHole1/sesmate.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/sesmate"
  end

  test do
    system bin/"sesmate", "--help"
  end
end
