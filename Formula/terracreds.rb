class Terracreds < Formula
  desc "Credential helper for Terraform Automation and Collaboration Software"
  homepage "https://github.com/tonedefdev/terracreds"
  url "https://github.com/tonedefdev/terracreds/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "03350f923184062c536bcd9ec7b9d0737a2ff7fe7f56b6e5b11315fd78396a79"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["TC_CONFIG_PATH"] = Dir.home
    system "#{bin}/terracreds", "config", "logging", "-p", Dir.home, "--enabled"
    File.exist?("#{Dir.home}/config.yaml")
  end
end
