class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/2.27.0.tar.gz"
  sha256 "bd51ff2747ee27d10fb5c7841b2ef7d550eb011b1cd9ced209cd7a66faef3011"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "317449f99db80877017627711e5ddd70b5d331e618f0562b078eab381df79ed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "618002aeb404cf30daf1a46b5802d1880a20b62736c225a25614cfc78cd9823f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bddf1ab6700622ec0300a00ca29edbb72e25565f7a9b7573031ec6233bcaa126"
    sha256 cellar: :any_skip_relocation, ventura:        "3c2876305293dd9f21f919aadf58db2af95e1374ceb255b24cdc49736d361b77"
    sha256 cellar: :any_skip_relocation, monterey:       "0dc5e7c4802700300da4b4fa7a58769173eb65cd017ccaeb85ceb0659443ffe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "025375408e2b11e98d9e9ced9254352adb7ddc066f47ab98477b60cca97cb97e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ebfddbb35efc9fbb03f58206909568e795447c8e94d7fd13c2aaea196c1e4d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
