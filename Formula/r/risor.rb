class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "3253a3e6e6f2916f0fe5f415e170c84e7bfede59e66d45d036d1018c259cba91"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc9073bb45f701f9ff39c4d43795b1f0114d8fe99b213a4d5e56cab834372ec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae7920cf800de73af866037c0f400e40dda6b26ca5dea1024a833416c20fbe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e4fb4390f4d183ce641ca7cb7173d69ead4ab3ea8424cfa70a895b3a41cda12"
    sha256 cellar: :any_skip_relocation, sonoma:        "952d9b3f1b7a0d6c5d155f7dbba7e6ed4d3496f72e6d730ab67ebe807e277b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46bfe28dea231137267ef0d4363a64b468980f6861fd4f74c0cc136f06efbd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cfa38a0b092a0f6d3907e181c93624ed96eecbc52d037fc466d01af33d6b386"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      tags = "aws,k8s,vault"
      system "go", "build", *std_go_args(ldflags:, tags:)
      generate_completions_from_executable(bin/"risor", shell_parameter_format: :cobra)
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
    assert_match "module(k8s)", shell_output("#{bin}/risor -c k8s")
    assert_match "module(vault)", shell_output("#{bin}/risor -c vault")
  end
end
