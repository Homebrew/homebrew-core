class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://github.com/tetratelabs/wazero/archive/v1.5.0.tar.gz"
  sha256 "d9695533ba0c1e297439feeafd701c0e4e24c916f82c1b933d323fc8392f1960"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b4f5d7217e7c3e599819db9e949fc0f40f02e83b40f5482343723b57305bf80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b12ba712fae63f2b6cd0138a7b59f393a3cccc2fbbc81df5e8026247dd63005"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d39edf868cd19d989edb86ee1bfc8fd4ff06626804ebdd762118d481cf4a276f"
    sha256 cellar: :any_skip_relocation, ventura:        "cc9df301383a777ade973977ae96d006278aeeeade365cfc1ea301fa73a7c458"
    sha256 cellar: :any_skip_relocation, monterey:       "4e56c5aec7e2e254956d73cb5b76b8abefa79f5fa897332b78768e15d651570e"
    sha256 cellar: :any_skip_relocation, big_sur:        "54c1f92ad65ab327f4e6124e1749d57b828c48d322f8c66ce19087aeccdf2ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a043345c1a66b6d209747831b541f335ef314d7a10f5d485daf3a1896430c03"
  end

  depends_on "go" => :build
  depends_on "wabt" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/tetratelabs/wazero/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/wazero"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/wazero version").chomp

    (testpath/"mount.wat").write <<~EOS
      ;; print the preopen directory path (guest side of the mount).
      (module
        (import "wasi_snapshot_preview1" "fd_prestat_get"
          (func $wasi.fd_prestat_get (param i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_prestat_dir_name"
          (func $wasi.fd_prestat_dir_name (param i32 i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_write"
          (func $wasi.fd_write (param i32 i32 i32 i32) (result i32)))

        (memory (export "memory") 1 1)

        (func $main (export "_start")
          ;; First, we need to know the size of the prestat dir name.
          (call $wasi.fd_prestat_get
            (i32.const 3) ;; preopen FD
            (i32.const 0)) ;; where to write prestat
          (drop) ;; ignore the errno returned

          ;; Next, write the dir name to offset 8 (past the prestat).
          (call $wasi.fd_prestat_dir_name
            (i32.const 3) ;; preopen FD
            (i32.const 8) ;; where to write dir_name
            (i32.load (i32.const 4))) ;; length is the last part of the prestat
          (drop) ;; ignore the errno returned

          ;; Now, convert the prestat to an iovec [offset, len] writing offset=8.
          (i32.store (i32.const 0) (i32.const 8))

          ;; Finally, copy the dirname to stdout via its iovec [offset, len].
          (call $wasi.fd_write
            (i32.const 1) ;; stdout
            (i32.const 0) ;; where's the iovec
            (i32.const 1) ;; only one iovec
            (i32.const 0)) ;; overwrite the iovec with the ignored result.
          (drop) ;; ignore the errno returned
        )
      )
    EOS

    system "wat2wasm", testpath/"mount.wat", "-o", testpath/"mount.wasm"

    assert_equal "/homebrew",
      shell_output("#{bin}/wazero run -mount=/tmp:/homebrew #{testpath/"mount.wasm"}")
  end
end
