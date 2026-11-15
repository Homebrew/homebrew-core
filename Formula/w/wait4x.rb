class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://github.com/wait4x/wait4x/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "4fbb68d1387128fed8d8072761e021f67853668287c37bfc7f52d6561dbf5f3e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8cd9e957e6dcda9e8a71d525154040783e20dc19a1b23bc17ea97246f9d68f54"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85a26eee38cd805c1caf15078bafe0ed21a7d839ff772910c8c6024cd043ae9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a34358f9719b38db18dcf5f8820e9b32947b2db269a3ac8a659b9c9b2e059796"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b6a0aa30f94f862d2d582849a7e9c56d83af683d461ad804ec7cfbf8bf4ff218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "13f71f6278714cc188d5947ef1f7b70fd1026f3564bcd033ec32dcc60695dba6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "build"
    bin.install "dist/wait4x"
    generate_completions_from_executable(bin/"wait4x", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end
