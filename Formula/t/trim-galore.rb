class TrimGalore < Formula
  desc "Quality and adapter trimming for FastQ sequencing reads"
  homepage "https://github.com/FelixKrueger/TrimGalore"
  url "https://github.com/FelixKrueger/TrimGalore/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "6dd4d99c10a2d1e740d8e49ee870b1f9a7ccb8ee94c0bc5183d2ae507492aab0"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/TrimGalore.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21715e4c80f487a2e3e4ad673e12cdfa872bde5685597b6790e062be97a275ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be9dd3a0cba6a7671eb0e3cbc426e30e621c3754831bcdbf25dfcafed47e9df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "981fa7a134a77f9ed8af9e91eaf7dfe6e37536a2bea3eb1baab6345fa55b331f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2475710430a340a61d03036f9b626226e3e2cd7f9a6544fc2ddbfe404488f19"
    sha256 cellar: :any,                 arm64_linux:   "95e72c2c77cb70c6348c5f5b4ff4053fb9a455ad61ac3ed42e5ea42789cfebdd"
    sha256 cellar: :any,                 x86_64_linux:  "5b67d87bfc3fd3e780117d9c7aa98485a02f0c39d99f3c0ce1df3df2957efa05"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trim_galore --version")

    (testpath/"reads.fq").write "@r1\n#{"A" * 30}AGATCGGAAGAGC\n+\n#{"I" * 43}\n"
    system bin/"trim_galore", "--dont_gzip", testpath/"reads.fq"
    assert_path_exists testpath/"reads_trimmed.fq"
  end
end
