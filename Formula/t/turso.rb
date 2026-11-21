class Turso < Formula
  desc "Interactive SQL shell for Turso"
  homepage "https://github.com/tursodatabase/turso"
  url "https://github.com/tursodatabase/turso/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "c678c98a1f7a7ed1cf609bfbc5655198de4c6e19d62a941875d4d161584aecde"
  license "MIT"
  head "https://github.com/tursodatabase/turso.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "fc378f9bb1e4654c401fbabbba2f936450175b97cdde92a202b93535969aede5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da619c4166fc3fcd356e1ad66f54eb732d296102a976c3780976fb560ed78ec9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74da09b245920c7cc4031ff12772cf1713bfe31d921c1e9e228bc1dc7fade554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ac62a5b3ddf562cbfe37fa8e7de2b181ac8e08b106260adfee365a30aadf760"
    sha256 cellar: :any,                 arm64_linux:       "b423dccc6bef567ab0e98f078252af4f31c53748659da3affbaee98bb8e946bf"
    sha256 cellar: :any,                 x86_64_linux:      "fb8ac6a8cd1acffc1671a045f3866b1e7290db6e444f5d6c44b0924c44ba6132"
  end

  depends_on "rust" => :build
  uses_from_macos "sqlite" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Rust 1.100 resolves std `Vec::new_in` first: https://github.com/tursodatabase/turso/issues/9463
    inreplace "core/index_method/fts/directory.rs", "DynVec::new_in(",
              "<DynVec<u8> as TursoVecInExt<u8, DynAllocator>>::new_in("

    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tursodb --version")

    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn bin/"tursodb", "school.sqlite", [:out, :err] => output_log.to_s
        r.winsize = [80, 43]
      end
      sleep 2
      assert_match "\".help\" for usage hints.", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
