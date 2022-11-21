class Shadowenv < Formula
  desc "Reversible directory-local environment variable manipulations"
  homepage "https://shopify.github.io/shadowenv/"
  url "https://github.com/Shopify/shadowenv/archive/2.1.0.tar.gz"
  sha256 "6cfdecb4f9684d0c536ab88847da5f314145f19bd504a8f13b59adf2966bb05c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76bbe8c6c92c0fbd63d3f4f801b869e8f836bff4bb6f82dba7dbe08972934f34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28aabdbb7ebfab527b9e4a1201172ac9cea7594cca8d41bd237797fa40f82246"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8862ba2e18219cfc43153b40535ffbeded2803651f20ebd7777d7eb4c2d9b1c6"
    sha256 cellar: :any_skip_relocation, ventura:        "4d91d62c013d0429d7451e1d549587d1fdc953240a6aaa94c38a7a0dde3635f7"
    sha256 cellar: :any_skip_relocation, monterey:       "0d78a4c4030d259278de1428c501629ed441c6079b5b4d41074f579b1119eb87"
    sha256 cellar: :any_skip_relocation, big_sur:        "395d18e1a7e6cd780fa1f403394ccab654b8005185239bd66b69e6068503a136"
    sha256 cellar: :any_skip_relocation, catalina:       "9dd1aef3e3c5c943ecf2e111d4f263b313792166b53671adb28f1d434eca3f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74bcc44128a24dd9802235e5d67dbadcce51806f677fc0b4c2d48d1e247bd5f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "#{buildpath}/man/man1/shadowenv.1"
    man5.install "#{buildpath}/man/man5/shadowlisp.5"
  end

  test do
    expected_output = <<~EOM
      EXAMPLE:
      EXAMPLE2:b
      EXAMPLE3:b
      EXAMPLE_PATH:a:b:d
      ---
      EXAMPLE:a
      EXAMPLE2:
      EXAMPLE3:a
      EXAMPLE_PATH:c:d
    EOM
    environment = "export EXAMPLE2=b EXAMPLE3=b EXAMPLE_PATH=a:b:d;"
    hash = "1256a7c3de15e864"
    data = {
      "scalars" => [
        { "name" => "EXAMPLE2", "original" => nil, "current" => "b" },
        { "name" => "EXAMPLE", "original" => "a", "current" => nil },
        { "name" => "EXAMPLE3", "original" => "a", "current" => "b" },
      ],
      "lists"   => [
        { "name" => "EXAMPLE_PATH", "additions" => ["b", "a"], "deletions" => ["c"] },
      ],
    }
    # Read ...'\"'\"'... on the next line as a ruby `...' + "'" + '...` but for bash
    shadowenv_command = "#{bin}/shadowenv hook '\"'\"'#{hash}:#{data.to_json}'\"'\"' 2> /dev/null"
    print_vars =
      "echo EXAMPLE:$EXAMPLE; echo EXAMPLE2:$EXAMPLE2; echo EXAMPLE3:$EXAMPLE3; echo EXAMPLE_PATH:$EXAMPLE_PATH;"

    assert_equal expected_output,
      shell_output("bash -c '#{environment} #{print_vars} echo ---; eval \"$(#{shadowenv_command})\"; #{print_vars}'")
  end
end
