class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/v1.2.0.tar.gz"
  sha256 "e6d1b31a124e8597f61b86f08b6a18168f9cd9da1db77f2a8dd1970b407b7610"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:    "6003cd60f9e85afa2dbb6a6a3e07dbfff6bba2a5df8fe9b6d3452907cd7d16f6"
    sha256 cellar: :any_skip_relocation, mojave:      "2700d10e8b75bb9daec60112aeaaf52878de609d8e2b7e8efcc1b02db2144939"
    sha256 cellar: :any_skip_relocation, high_sierra: "86291d5a0cdee29beae607f70436c61db901c6483a6f9eaab63c1c4385a4112c"
  end

  depends_on "postgresql"

  # Fix for postgresql 11 compatibility:
  # https://github.com/arkhipov/temporal_tables/issues/38
  patch do
    url "https://github.com/mlt/temporal_tables/commit/24906c44.patch?full_index=1"
    sha256 "bb2a8b507b6e6a42a25c8da694f889ee55f40b6ae621190348155b5e9198244d"
  end

  # Fix for postgresql 12 compatibility:
  # https://github.com/arkhipov/temporal_tables/issues/47
  patch do
    url "https://github.com/mlt/temporal_tables/commit/a6772d195946f3a14e73b7d3aff200ab872753f4.patch?full_index=1"
    sha256 "c15d7fa8a4ad7a047304c430e039776f6214a40bcc71f9a9ae627cb5cf73647e"
  end

  def install
    ENV["PG_CONFIG"] = Formula["postgresql"].opt_bin/"pg_config"

    # Use stage directory to prevent installing to pg_config-defined dirs,
    # which would not be within this package's Cellar.
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end
end
