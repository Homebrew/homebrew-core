class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "579b32cea56838da7195cc8c0e9dabb54434f289c1634c9e4da7f4f877e775c8"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8079b0fa41c982f12cc548129fef10cf2329b357051a0796dbbb7fcf5425ed62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "358dbd405d5485138511119c469f0a8a0b9ddd5ba51831646fa2f6a5da6f6e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc6bf940a7ad825ae45f0414ce9506facfe19667389c917d785be9499ce26801"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1a1a731f9cc465f5e5286c51e4b37baa303fbbaa68b89ffcc285d7ff4580a85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "521aa3acbb20c93f2674651ca45f4bb101646ef6dd392e2e2292a2647a34964a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095a2a948fcd7a1365520abf36ef85cd37bd2a1310a12e9db9c436948b715222"
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
