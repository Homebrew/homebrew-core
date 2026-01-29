class UnifiedCourierTracker < Formula
  desc "Track packages from Blue Dart, DTDC and Delhivery (TUI)"
  homepage "https://github.com/anir0y/unified-courier-tracker"
  url "https://github.com/anir0y/unified-courier-tracker/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e7e590c455bb83e6aa36c4f53e7e742119916858af38d2ddfedad6faeff22e88"
  license "MIT"

  depends_on "python@3.12"

  def install
    libexec.install "track_shipments.py"
    (bin/"unified-courier-tracker").write <<~EOS
      #!/bin/bash
      exec "#{Formula["python@3.12"].opt_bin}/python3" "#{libexec}/track_shipments.py" ""
    EOS
    (bin/"unified-courier-tracker").chmod 0o755
  end

  test do
    # --help should print usage and exit 0
    assert_match "usage", shell_output("#{bin}/unified-courier-tracker --help")
  end
end
