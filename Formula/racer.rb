class Racer < Formula
  desc "Rust Code Completion utility"
  homepage "https://github.com/phildawes/racer"

  url "https://github.com/phildawes/racer/archive/v1.1.0.tar.gz"
  sha256 "f969e66d5119f544347e9f9424e83d739eef0c75811fa1a5c77e58df621e066d"
  head "https://github.com/phildawes/racer.git"

  depends_on :rust => :build # rust MUST be up to date or else racer will produce invalid completions

  resource "rust_source" do
    url "https://static.rust-lang.org/dist/rustc-1.9.0-src.tar.gz"
    sha256 "b19b21193d7d36039debeaaa1f61cbf98787e0ce94bd85c5cbe2a59462d7cfcd"
  end

  def install
    system "cargo", "build", "--release"
    (libexec/"bin").install "./target/release/racer"
    bin.write_env_script(libexec/"bin/racer", :RUST_SRC_PATH => "#{HOMEBREW_PREFIX}/share/rust_src/current")
    resource("rust_source").stage do
      rm_rf(["src/llvm", "src/test", "src/librustdoc", "src/etc/snapshot.pyc"])
      (share/"rust_src/1.9.0").install Dir["./src/*"]
    end
  end

  def post_install
    ln_sf (share/"rust_src/1.9.0"), (share/"rust_src/current")
  end

  test do
    ENV["RUST_SRC_PATH"] = share/"rust_src/src"
    system "#{bin}/racer", "complete", "std::io::B"
  end
end
