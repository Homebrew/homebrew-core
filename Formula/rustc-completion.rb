class RustcCompletion < Formula
  desc "Bash completion for rustc"
  homepage "https://github.com/roshan/rust-bash-completion"
  head "https://github.com/roshan/rust-bash-completion.git"

  stable do
    url "https://github.com/roshan/rust-bash-completion/archive/0.12.1.tar.gz"
    sha256 "562f84ccab40f2b3e7ef47e2e6d9b6615070a0e7330d64ea5368b6ad75455012"

    # upstream commit to fix an undefined command when sourcing the file directly
    patch do
      url "https://github.com/roshan/rust-bash-completion/commit/932e9bb4e9f28c2785de2b8db6f0e8c050f4f9be.diff?full_index=1"
      sha256 "2e1606d329f6229e7b57d8c733bc7352ed811d6295c0331eafc2210652d548ca"
    end
  end

  bottle :unneeded

  def install
    bash_completion.install "etc/bash_completion.d/rustc"
  end

  test do
    assert_match "-F _rustc",
      shell_output("source #{bash_completion}/rustc && complete -p rustc")
  end
end
