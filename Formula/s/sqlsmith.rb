class Sqlsmith < Formula
  desc "Random SQL query generator"
  homepage "https://github.com/anse1/sqlsmith"
  # TODO: Switch to the release tarball when the next release is made
  url "https://github.com/anse1/sqlsmith/archive/refs/tags/v1.5.tar.gz"
  sha256 "828ee3e816b94848627e8132d32ade6339dbcbba5469437dc9a6a8335d4dab23"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/anse1/sqlsmith.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "292e6cfdf04ed8f5230af4fe96a82070bdd3d5556944f704ecf9040f7bcc7097"
    sha256 cellar: :any, arm64_sequoia: "c1ea6cb97d77862f8fb57d9bf930c271fc3b7ab31f94ff44a95dbf6a1721dbb0"
    sha256 cellar: :any, arm64_sonoma:  "e1ad91268c06dd1ed90e9ce1d3d6a0c406d4b3906c5a35382f55738c20dfe75d"
    sha256 cellar: :any, sonoma:        "553c79f094d5dac3a281f8453c459d83a23bd56bee125a29eb136e5be88bd89c"
    sha256 cellar: :any, arm64_linux:   "f7640ea2c2d47008487595723c9b6380cf936a439ff8a25960e26f60e3e35dff"
    sha256 cellar: :any, x86_64_linux:  "e391dbb5aad821b71e981cfa40d6a9fcdcecc8e022fe5fa45be01fecb6452dc4"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
  depends_on "automake" => :build

  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "libpqxx"

  uses_from_macos "sqlite"

  def install
    ENV.append_to_cflags "-DNDEBUG"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    cmd = %W[
      #{bin}/sqlsmith
      --sqlite
      --max-queries=100
      --verbose
      --seed=1
      2>&1
    ].join(" ")
    output = shell_output(cmd)

    assert_match "Loading tables...done.", output
    assert_match "Loading columns and constraints...done.", output
    assert_match "Generating indexes...done.", output
    assert_match "queries: 100", output
    assert_match "impedance report:", output
  end
end
