class Singularity < Formula
  desc "Application containers for Linux"
  homepage "https://www.sylabs.io/singularity/"
  url "https://github.com/sylabs/singularity/releases/download/v3.6.2/singularity-3.6.2.tar.gz"
  sha256 "dfd7ec7376ca0321c47787388fb3e781034edf99068f66efc36109e516024d9b"
  license "BSD-3-Clause"

  depends_on "go" => :build
  depends_on "openssl@1.1" => :build
  depends_on "libarchive"
  depends_on :linux
  depends_on "pkg-config"
  depends_on "squashfs"
  depends_on "util-linux" # for libuuid

  def install
    system "./mconfig", "--prefix=#{prefix}"
    cd "./builddir" do
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/singularity --help")
    assert_match version.to_s, shell_output("#{bin}/singularity version")

    system bin/"singularity", "sif", "new", "test.sif"
    assert_predicate testpath/"test.sif", :exist?

    output = shell_output("#{bin}/singularity sif header test.sif")
    assert_match "Launch:", output
    assert_match "#!/usr/bin/env run-singularity", output
    assert_match "Magic:", output
    assert_match "SIF_MAGIC", output

    output = shell_output("#{bin}/singularity verify test.sif 2>&1", 255)
    assert_match "Verifying image: test.sif", output
    assert_match "Failed to verify container: integrity: no groups found", output
  end
end
