class Shtool < Formula
  desc "GNU's portable shell tool"
  homepage "https://www.gnu.org/software/shtool/"
  url "https://ftpmirror.gnu.org/shtool/shtool-2.0.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/shtool/shtool-2.0.8.tar.gz"
  sha256 "1298a549416d12af239e9f4e787e6e6509210afb49d5cf28eb6ec4015046ae19"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    manifest_sha256 "17838a10eff518949ff4e1c796111f5a454026ec9dc298a6fe164a7e24cf6fb6"
    sha256 cellar: :any_skip_relocation, all: "3edcbc54268a95648cc37c6f08b9ccf66968d3a7b8f76966c4038a1559203a56"
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/shtool echo 'Hello World!'").chomp
  end
end
