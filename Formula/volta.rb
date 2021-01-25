class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.1",
      revision: "56a306c4fd0c0a88d7ff986724d5cf8e1af920b1"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4e7951a24ade9e61114ec23e5920fdcb89df268722b827122b666f391c4e6038" => :big_sur
    sha256 "a5c08ed458919dbf9c4468e667b8b1af83f0f0df422006fea5866fa0edeae526" => :catalina
    sha256 "ba38fc76ebf6147ed51db93469ef0b880b6368ca72c4bb7e4acf1fcd2109e922" => :mojave
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
