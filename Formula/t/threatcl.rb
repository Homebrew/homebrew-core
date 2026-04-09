class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "823b231e4538cd110069234a4cf72c7bcca759b0d5937b2331b32e173794793a"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "482854397a898c5316fe3377ac1b51dc4d543f550a96badb531c9c02da9aac40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829bb1c5d7147fe2a718a12fdb7eb3538c6249f17fc3d745ca99ed9cc59d8e69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2c9bbe705f32a7e97edefbe6e8121f12db6dc3bab4072a9c6c69500a6c0aff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f16094663f62f575f2128047bf09e64c44e7079057e25b06071dfa1e33c6d202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33d3ee537a1aa3f48f3d784c1823e676097efa3302d3f6ac9d66ef7fb4600a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a215f35330e228a68e1d616092fd8a279ffb003d5faaa92e326299470ede0b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
