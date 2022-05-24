class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.6.tar.gz"
  sha256 "faf33a97797b95097c08ebb7c2451ac9835907254d89863b10ab5e0813b5fe5f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b13fb7360bf22415291f9567ecbdd73be518370ed0d586b126f4799235346e50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18c80fe2725f822518e07c67d37f410ba97387ad956d83e57caf33ac29e80d25"
    sha256 cellar: :any_skip_relocation, monterey:       "9d7ced5db7e35961bc033feefd5ccac3e2a92aab40639b6551e7025917c010ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "954897383d176858ae3756214f1cd328813aca21c8a1680e28574b75d60f176c"
    sha256 cellar: :any_skip_relocation, catalina:       "7a596311c78da626809ba278bd318499d9552ee8ada8ae302abe4b3481b2245e"
    sha256 cellar: :any_skip_relocation, mojave:         "779ae77105d505f8532438b83acb54f915b5a917c66aecfc21ecdd86cf550b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc1bd3d85302acebc3f77b87d9251cafa625c84cf6f3cc0f675af9db0e4c016"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Completion scripts and manpage are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/sd-*/out"].first
    man1.install "#{out_dir}/sd.1"
    bash_completion.install "#{out_dir}/sd.bash"
    fish_completion.install "#{out_dir}/sd.fish"
    zsh_completion.install "#{out_dir}/_sd"
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
