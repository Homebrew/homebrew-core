class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2016-10-01.tar.gz"
  version "20161001"
  sha256 "11fd87507450fe2bbdcdb3971ea2e0bedd71a02f064118ef1ac60aa6ac85992d"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "45eaa77510527ced7036baae2c3c4bd0b08fa113e64bf5bf2825a6cd04f96134" => :sierra
    sha256 "e985cf93476de797b6c2dd643c141f35f2bfa800952c98ac56578939ae738fa4" => :el_capitan
    sha256 "48a2b946c7646ef1ceeea4ffaf719fbd353626cf03a1012f356ad91506ff8c1f" => :yosemite
    sha256 "b7652eee1b647fa5ddb68fbae9f34729ec0b0242c86ff28d1ab093822c782874" => :mavericks
  end

  needs :cxx11

  # https://github.com/google/re2/issues/102
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70932
  fails_with :gcc => "6" do
    cause "error: field 'next_' has incomplete type 'std::atomic<re2::DFA::State*> []'"
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    system "install_name_tool", "-id", "#{lib}/libre2.0.dylib", "#{lib}/libre2.0.0.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
