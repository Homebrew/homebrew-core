class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/v2.0.3.tar.gz"
  sha256 "6529d521a7fa006808cd07331f31256e91773ec7e1a0c7839cd14884034fb185"
  license "MIT"
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "7952cd1e77673a9e64b71ed8081ef47b0a0c7218475c7cf59b76909a108499c4"
    sha256 cellar: :any_skip_relocation, catalina:    "a73bd34611c56aefe57e5491191ae90109f779f49ecacee332c0e55745e84c89"
    sha256 cellar: :any_skip_relocation, mojave:      "bce926c779ee605e3f36d9135dfd08bb898f62440cf04e5bcd991afd517931f2"
    sha256 cellar: :any_skip_relocation, high_sierra: "5f6278c15bd1487cbdee6b871057074b1a548a9dfba7a98b202d3ccbc12966c2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    system bin/"vultr", "version"
  end
end
