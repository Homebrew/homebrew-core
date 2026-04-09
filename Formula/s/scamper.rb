class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20260331.tar.gz"
  sha256 "1bd3a025dc8ded231df2fd72c92c5b85fc1e389af6e9cb020c02067b811a9917"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b66da6bf575a09129525df875a5801041b8500056ea48628b3de8a019046256"
    sha256 cellar: :any,                 arm64_sequoia: "e4c0ef726aacbd18fba706a5331f0e2728c5ee2fb8b2ce296ea90b9a3fbffde1"
    sha256 cellar: :any,                 arm64_sonoma:  "551631baac9ed847c91ba7f60a048bd21489740186425bf6045f932433375880"
    sha256 cellar: :any,                 sonoma:        "a92048aac44d9b09629e3de6bc5e86ce01af75111a6907477ea87ee65f9711e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4238531e2587815a576c810e08c3e6d0eba9586052a13c1176e80a01cb42fd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa766a6c944e5291c4d3b9b5d908463f0b6db0339b38fb9ab1e0590731ae08e"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end
