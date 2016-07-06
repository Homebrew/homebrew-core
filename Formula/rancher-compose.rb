class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "http://docs.rancher.com/rancher/latest/en/rancher-compose/"
  url "https://github.com/rancher/rancher-compose/releases/download/v0.8.2/rancher-compose-darwin-386-v0.8.2.tar.gz"
  sha256 "116af6f0228da287959e3db76f6de56c819add159e8f1948b66c4b27b76ad889"

  def install
    bin.install "rancher-compose"
  end

  test do
    assert_match /#{version}/, shell_output(bin/"rancher-compose --version")
  end
end
