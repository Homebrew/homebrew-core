class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "e700fcc1fecaaec3f90e8b2df7d2fc3ee25bc6b6cef06f8532e07774d6363e7e"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd42d8b972b1f2d166b664a6c13c79b2ba730107f4c7a3f453b5c1f1f9c7bd9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec850f6d7b1bf267536bd6417c49bc114272ab13906dc9005c47debf90bb65e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bd3fdf45c917519f00fc8c8da601434f6d2cababe891582c7cb5a7d5b9b1a2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e9091bb945a1d76e012c1e3bceb2f22e9e33f1476a699491b04a0b5c2c2bc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1af7f387e07b91841b02b4367f9788666fe8c168470742228f7b42d3255111c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0955fe1c1a5f07d8c0959de2e32f11fdd32d7edf3f2124c6bc117fc9f57ff71e"
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
