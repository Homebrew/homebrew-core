class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.18.tar.xz"
  sha256 "69980a0058c848f4d1117121cc9153f2daace5561d37bfdb061473f035fc35ef"
  license "MIT"

  livecheck do
    url "https://archives.eyrie.org/software/kerberos/"
    regex(/href=.*?remctl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "65ed94e43fc5b48a50c38a417453622fda2f57d2845db6555cda4b1366f7da8e"
    sha256 cellar: :any,                 arm64_sequoia:  "a22e6463332dd82c82e286ebfdcb40577f163967c473d012c468c8b215e905e8"
    sha256 cellar: :any,                 arm64_sonoma:   "02f8ce6be131029af0d88382303757c5ac9a149bf0c66156b9093873af61f53d"
    sha256 cellar: :any,                 arm64_ventura:  "a7d183ea3da3af640ed517baa9623a207098627c651d1028819c1e8c7536f2e1"
    sha256 cellar: :any,                 arm64_monterey: "49d5e57e353ff5342a2a915daadb5adf29d632cbf764278b3925e34480f1a0d4"
    sha256 cellar: :any,                 arm64_big_sur:  "67ab815bbb6094595b818fdd38d2c697a4ac6dd0a5e9ab6e9a17013cd42683fd"
    sha256 cellar: :any,                 sonoma:         "af23ebd8bd1f313d7c7457158f8bf1f16caecede018e8bbfda8581b079646fe0"
    sha256 cellar: :any,                 ventura:        "4474c52f63e68fa6cd369b00d41ee5963ab84f4f3156b94b09e3e3328c4c3037"
    sha256 cellar: :any,                 monterey:       "c071e9621162fd5e00e2735f1eb10e3eba302f2f5430740b4122c0ab2800e7d2"
    sha256 cellar: :any,                 big_sur:        "c98f0e9729545d32cf87de9eeb6cb5d9d889b26978903823cb78fadd10b03713"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "325fd3e1bfce192eb6ea17639265b1f619ef95db046fbbf87efa92e8b1e0baa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def6439b11bef8a6ee81d387991e0995b9fe76928e9dbd69bd65ea09b6931d1b"
  end

  depends_on "libevent"
  depends_on "pcre2"

  uses_from_macos "krb5"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-pcre2=#{Formula["pcre2"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"remctl", "-v"
  end
end
