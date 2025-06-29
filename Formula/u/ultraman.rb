class Ultraman < Formula
    desc "Manage Procfile-based applications. (Rust Foreman)"
    homepage "https://github.com/yukihirop/ultraman"
    url "https://github.com/yukihirop/ultraman/archive/refs/tags/v0.4.0.tar.gz"
    sha256 "5e0f329f5d7d69f9546df81303328b11d3d355194109c11ef7209773bb9a1d86"
    license "MIT"
  
    depends_on "rust" => :build
  
    def install
      system "cargo", "install", *std_cargo_args
      generate_completions_from_executable(bin/"ultraman", "completion",
                                         shells: [:bash, :zsh, :fish])
    end
  
    test do
      assert_match version.to_s, shell_output("#{bin}/ultraman --version")
      assert_match "USAGE:", shell_output("#{bin}/ultraman --help")
      assert_match "bash", shell_output("#{bin}/ultraman completion bash")
      assert_match "zsh", shell_output("#{bin}/ultraman completion zsh")
      assert_match "fish", shell_output("#{bin}/ultraman completion fish")
    end
  end
  