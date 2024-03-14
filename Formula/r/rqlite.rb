class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.23.0.tar.gz"
  sha256 "d9583bb257fa80c7924ba71dbdf3b1fa756e4fce3709983720a169f3f31736ce"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acf64dd2ad4b9295e756b8818677bbe46b0ace935853488582454504d6534d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9463d44dd9b272335e9d1294b0d0e4e8c530cc4e44f8401988ddcd6f7dd621be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a18a7b1b7937175ea0f9f92eb9e175a1a3d5228455dbf58513507a478f826e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "127ce12f904814aba7636d1a653adb4c8165d4dd33f73741414029cd2341d410"
    sha256 cellar: :any_skip_relocation, ventura:        "1b71498ba15ac684bec512b676a33f33a15a8e6109a4dc3233c53a2baa07ea33"
    sha256 cellar: :any_skip_relocation, monterey:       "a30fa8056362da0a02062c3611bf4dc37c66c584f50dd8244e4cdb32904fe37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712092192eda0c5eb87bda39ab89e644547470e21d5387b2c493da6ab3997c7a"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
