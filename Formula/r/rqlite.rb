class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "https://www.rqlite.io/"
  url "https://github.com/rqlite/rqlite/archive/refs/tags/v8.32.0.tar.gz"
  sha256 "71ae0ca2e080c3a32fed5d129506f5749a59feaa63664109df8482560a6a35ca"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4896ae122e579374ae82c5e64adc2576b68c6d4ae65a80a86b105c65cadbe3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5542633891fd99c6c0d003ffdc6fb2c4c6ebe8855ee063cf483e0d8a40e6ad9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "139a3c69b5476526e0002c8e650aa2fdd9c3dce9e3a4e10adb0fb569cfe47b16"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ce4148d6f96a63337f52ee95897b4fd22aae0e5db03c3654226ecd48bcd37cb"
    sha256 cellar: :any_skip_relocation, ventura:       "8ee43bb8aa7aadb84be7c10b2ba1120377ceb4087db284ba0a762649eba58f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5778e84406275a0d4d9c83e9d65d86d0ab0975e7ae9c94794272d3fe65756c59"
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
