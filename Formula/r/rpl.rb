class Rpl < Formula
  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://github.com/rrthomas/rpl/releases/download/v2.0.4/rpl-2.0.4.tar.gz"
  sha256 "cb48bf6712cd4e7aa70b2225dcab0cb081582181d7e9766ada196b3ab5b2ec61"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9818e66d4be4d4459dc59bba02beca0044596cf508c26ba29f7cb98f4c0ab1e"
    sha256 cellar: :any,                 arm64_sequoia: "b628ab24e76ae6d47df7e7b409b745f62d1e068053adb8234b7bf6dc64ad7ff8"
    sha256 cellar: :any,                 arm64_sonoma:  "be9e98e87ce5b54a49d72f9c7028601daea83bab9491015f43a00d9c4c90846b"
    sha256 cellar: :any,                 sonoma:        "efd688e33dad7f7bc9de4319febb6ed07e836fd5ed8c2fe1c2ec4035c97ad852"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0049ccf0f0623607cbb7e5123b55b0699948e5a9691e222763b12450fc4cbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1ea919345b90a09395c9a0f57441c3b0a917ef1f2e7f4b1af006e66e96bce24"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "pcre2"
  depends_on "uchardet"

  on_macos do
    depends_on "gettext"
  end

  # TODO: Remove next release
  resource "vala-extra-vapis" do
    url "https://gitlab.gnome.org/GNOME/vala-extra-vapis/-/archive/6b8a3e4faaabc462f90ffcb0cf0f91991ee58077/vala-extra-vapis-6b8a3e4faaabc462f90ffcb0cf0f91991ee58077.tar.bz2"
    sha256 "161fbc1e2ac51886ec52c0ee8db69d6afe408279ec79a8bea2b472a23fef9e99"
  end

  # Backport fix for newer PCRE2.
  # TODO: Remove patch and `vala` dependency in next release
  patch do
    url "https://github.com/rrthomas/rpl/commit/6e452376e32c230819078d92248433e800878bb0.patch?full_index=1"
    sha256 "3b3634aaeff9e0eac0f3ec22a1a0346c1c56c8fd30a38aa12d90b3e5b71ce0fa"
  end

  def install
    (buildpath/"vala-extra-vapis").install resource("vala-extra-vapis")

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
