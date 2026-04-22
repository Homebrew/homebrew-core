class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "24a6900433772c927265ce3aa78968ce9fe653748efb760fa5fb9178f20ee2ca"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7bdf7f369782f188f64490a70d460b5f3b65e6223580b0b2664c6ed0abd904f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a024ea9737ffe6ec80e6cc8005b2161a8ff97fa949c86df8df8b29a1980e619"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f78a48e3dee4f528f5b9002698ece79b4b377a16b7ac757000bc1d362becd9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "01afe27a2092e31ebb3791f3d3239c581994f7579eeccad30819f5b788a98fbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13ea2d56e539d5ff89150bb450e8dec8031cff92037b64649ce01b2599c33e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91491ebcb79c2d01d397e71b93a97a3cb56004bde25647cd5c5648044f4d39ac"
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
