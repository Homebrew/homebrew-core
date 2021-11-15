class TemporalTables < Formula
  desc "Temporal Tables PostgreSQL Extension"
  homepage "https://pgxn.org/dist/temporal_tables/"
  url "https://github.com/arkhipov/temporal_tables/archive/v1.2.0.tar.gz"
  sha256 "e6d1b31a124e8597f61b86f08b6a18168f9cd9da1db77f2a8dd1970b407b7610"
  license "BSD-2-Clause"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0f993c548b4712d06a62910c41a8a3353f4787c150993066bc9065234e1c040"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ace1bc50036de0db253faad559c125c6f47496308b78ae9c81796cb19576fb62"
    sha256 cellar: :any_skip_relocation, monterey:       "9261b086bc9ac6276b83d3b7a742f6eb1835c2a3dbc66e0e1030d577359d361b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbca0fa6293665bf8441fcaa6d560c7414b9cffb0e1e6ec0b05ae5abb75ead19"
    sha256 cellar: :any_skip_relocation, catalina:       "232faff661afb06b3b5c9a496a7d6781cb4c5d469080fea2903429472c1049e6"
    sha256 cellar: :any_skip_relocation, mojave:         "bbf936aa039c98a3226fa8c3635d192d807826a9753fcee99514f212fc6f85c3"
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

  # Fix for postgresql 13 compatibility:
  # https://github.com/arkhipov/temporal_tables/issues/55
  patch do
    url "https://github.com/bbernhard/temporal_tables/commit/23284c2a593d3e01f7b4918c0aaa8459de84c4d8.patch?full_index=1"
    sha256 "c1e63befec23efbeff26492a390264cbc7875eaa3992aa98f3e3a53a9612d0e0"
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
