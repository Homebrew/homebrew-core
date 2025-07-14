class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.51.0.tar.gz"
  sha256 "0013f2edbfde15d4217e041b5eb156ae372de9b7df8b16cefbe010ac0c816c96"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3a4391f473ce2e471424eb38db57b57dc5aafb42cf603a9263fac1cac0a9da5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a3f7be9d623236dcc225ef763ee4b07810af375a266adb346847c829c28097d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a3dbec97f33e097071e0c16b9ffe1bf6527aaa7d226671ed17dcfbe4d05331b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b46fc197d067ac408758a575e52652a3d9be2d145994948cc5914574ccfd79c5"
    sha256 cellar: :any_skip_relocation, ventura:       "44a398b4ac0c429655565240d953ea247c921aff243953830f0752a5a620d7d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7add6a9cdc882f6d6183b94ff997c16bcc1409540fe5a5c811683fd6db81f6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "041e439181ea2a4b398983a05828e96bf5aabb931c998356ad4b88c43ecf3c00"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
