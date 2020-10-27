class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
    tag:      "0.2.4",
    revision: "f4a04cf3a6b003cb4b06e31ce0180066c764e53b"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7efa507c27623d5b9a6ac0feeaadef296504b3df67ce116dfa895e4041a09b12" => :catalina
    sha256 "3fbc571af7d5d32e8261efd9a016dfa192c45a5547de52199134409b76e6095b" => :mojave
    sha256 "9c32615c0b99a6f410529912e9cd8d701730b04ccb333eca2cdc7bcf6c027332" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"whalebrew", "."
  end

  test do
    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
