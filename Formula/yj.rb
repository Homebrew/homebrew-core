class Yj < Formula
  desc "CLI to convert between YAML, TOML, JSON and HCL"
  homepage "https://github.com/sclevine/yj"
  url "https://github.com/sclevine/yj/archive/v5.0.0.tar.gz"
  sha256 "df9a4f5b6d067842ea3da68ff92c374b98560dce1086337d39963a1346120574"
  license "Apache-2.0"
  head "https://github.com/sclevine/yj.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c90dea4f4b820ec8b19b9d5f853ece65ed308c49e807ef8a11e47136f0e175c" => :catalina
    sha256 "0c90dea4f4b820ec8b19b9d5f853ece65ed308c49e807ef8a11e47136f0e175c" => :mojave
    sha256 "0c90dea4f4b820ec8b19b9d5f853ece65ed308c49e807ef8a11e47136f0e175c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.Version=#{version}", *std_go_args
  end

  test do
    assert_match '{"a":1}', shell_output("echo a=1|#{bin}/yj -t")
  end
end
