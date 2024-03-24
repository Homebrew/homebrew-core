class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "021ceacfc91b61a981ac03f0f0b42dd135ade9d72a70187b85b59be584813ea5"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c413eb20b6f2a9634cb76227e62c858a446034eac435e2ebc0d7d481f4d225b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "199309f05c1ce98132d11510ae94bdf4e491463b94780330c41cfae308bf0c8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d3b4fb166045564b95884eef624b8ede495c6d0d065d2ce250fda7e5da524ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b2423b8a07bbd3a0ff1869b49324ab9de8c974b097c5f7cba434d5846d39a92"
    sha256 cellar: :any_skip_relocation, ventura:        "8cf83a2e2009d0c9903e2eace3c0c753d382e1d22adc306dd8197336dc494c14"
    sha256 cellar: :any_skip_relocation, monterey:       "07256e01ada9ffc61ce0d11d732f727257e86f3881bc10599e73233cb7dea434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d11d4cca492289db9eb0ee29af3e8f5a03c4824391d32cd8ba7e1b1bc7fdda4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
