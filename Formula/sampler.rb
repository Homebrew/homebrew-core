class Sampler < Formula
  desc "Tool for shell commands execution, visualization and alerting"
  homepage "https://sampler.dev"
  url "https://github.com/sqshq/sampler/archive/v1.1.0.tar.gz"
  sha256 "8b60bc5c0f94ddd4291abc2b89c1792da424fa590733932871f7b5e07e7587f9"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"sampler"
  end

  test do
    assert_includes "specify config file", shell_output("#{bin}/sampler")
  end
end
