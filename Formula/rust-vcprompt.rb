class RustVcprompt < Formula
  desc "Informative version control prompt for your shell"
  homepage "https://github.com/sscherfke/rust-vcprompt"
  url "https://github.com/sscherfke/rust-vcprompt/archive/0.1.0.tar.gz"
  sha256 "3c51261c7b75f04de566d97a95530521f71fb8b99529deab5ce8af97702c7acf"
  head "https://github.com/sscherfke/rust-vcprompt.git"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/vcprompt" => "rust-vcprompt"
  end

  test do
    mkdir "repo" do
      system "git", "init"
      ENV.keys.grep(/^VCP_[A-Z]+/).each { |k| ENV.delete(k) }
      assert_equal " ±\e[34mmaster\e[00m|\e[32m\e[01m✔\e[00m\n", shell_output("#{bin}/rust-vcprompt")
    end
  end
end
