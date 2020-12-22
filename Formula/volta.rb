class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.0",
      revision: "d523e32f03f8c4a653ded9a73fb4cc8a8b49ea22"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1f8252db32da052bd833de2f3e71bfd73b9c35e8b45e18c59130de3e60f73970" => :big_sur
    sha256 "9ed05f093675d06e11d11527f9a8d84683c425cb1e13c7da23e2727023b8da4b" => :catalina
    sha256 "dd9a7fa26847cfedde18605a26d26966aaf1f3531e0ba933bd3201c40572ffb9" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
