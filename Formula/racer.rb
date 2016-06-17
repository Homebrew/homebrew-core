class Racer < Formula
  desc "Rust Code Completion utility"
  homepage "https://github.com/phildawes/racer"

  url "https://github.com/phildawes/racer/archive/v1.1.0.tar.gz"
  sha256 "f969e66d5119f544347e9f9424e83d739eef0c75811fa1a5c77e58df621e066d"
  head "https://github.com/phildawes/racer.git"

  depends_on "rust" => :build

  resource "rust_source" do
    url Formula['rust'].stable.url
    sha256 Formula['rust'].stable.checksum.hexdigest
  end

  def install
    system "cargo", "build", "--release"
    (libexec/"bin").install "./target/release/racer"
    (bin/"racer").write_env_script(libexec/"bin/racer", :RUST_SRC_PATH => "#{HOMEBREW_PREFIX}/share/rust_src/current")
    resource("rust_source").stage do
      rm_rf ["src/llvm", "src/test", "src/librustdoc", "src/etc/snapshot.pyc"]
      (share/"rust_src/#{Formula['rust'].stable.version}").install Dir["src/*"]
    end
  end

  def post_install
    ln_sf (share/"rust_src/#{Formula['rust'].stable.version}"), (share/"rust_src/current")
  end

  test do
    system "#{bin}/racer", "complete", "std::io::B"
  end
end
