class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.5.tar.gz"
  sha256 "f4731fd6bd992eed06ed9326cdef22093605ff97df1dd856e31c5015f0720c66"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "44240033f8630edb2524e9cee7ee30b56cea0d7c14a24f9362c311caa5b9fa4e" => :catalina
    sha256 "970858444ff3977f4e12e0d2b5f9f617c1abb6f273e835d11a5cef014b8fe854" => :mojave
    sha256 "5457b2b3f96c0f57d40d9fddf313116ac1f7b0c1d7203cd6b1b1b3ec7c9995b2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/sd-*/out"].first
    man1.install "#{out_dir}/sd.1"
    bash_completion.install "#{out_dir}/sd.bash"
    zsh_completion.install "#{out_dir}/_sd"
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
