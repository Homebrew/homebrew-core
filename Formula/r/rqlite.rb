class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.20.2.tar.gz"
  sha256 "09bbc3c65e8e5109f56d8fede6e51d7a524a9ee227fb6c8e83bf1d03969293ae"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f53d7ff10a196598f6a9a0054ff4735bb034d10e1491100641a93deafb06f685"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f992941d128ac99763a198dfc643b8840ed7c364286b2a7d75382474a034d038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eef18201b9fe6d31d857f973b5205941f75f4707294f1961446a8413069b270"
    sha256 cellar: :any_skip_relocation, sonoma:         "8471eef42a844e908058bf4da70e6f29d2dea8945e396575ffaea50c92094b42"
    sha256 cellar: :any_skip_relocation, ventura:        "bf169c74441439314cfaefe23c7fb5afe112803f3f5640261db0d2129adfd5cf"
    sha256 cellar: :any_skip_relocation, monterey:       "87095bafb422cf5516538ef6c53bc4a40b9254ded914796a543a3114e4f33023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d9301ca6c382d9914b789309a80c9b45eb2812dd9796c2d204346c33e58710"
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
