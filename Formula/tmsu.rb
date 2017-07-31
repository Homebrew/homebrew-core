require "language/go"

class Tmsu < Formula
  desc "Tag your files and then access them through a nifty virtual filesystem"

  homepage "https://tmsu.org/"

  url "https://github.com/oniony/TMSU.git",
      :tag => "v0.6.1",
      :revision => "54dcf63749d24b7f2713c7ccfc2348e2053c79cc"

  head "https://github.com/oniony/TMSU.git"

  depends_on "go" => :build

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
        :revision => "afe454f6220b3972691678af2c5579781563183f"
  end

  go_resource "github.com/hanwen/go-fuse/fuse" do
    url "https://github.com/hanwen/go-fuse.git",
        :revision => "5690be47d614355a22931c129e1075c25a62e9ac"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "5f8847ae0d0e90b6a9dc8148e7ad616874625171"
  end

  # Compile fixes for OS X; cherry-picked from v0.7.0 (unreleased)
  patch :DATA

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "make", "compile"

    bin.install "bin/tmsu"
    sbin.install "misc/bin/mount.tmsu"
    man1.install "misc/man/tmsu.1"
    (share/"zsh/site-functions").install "misc/zsh/_tmsu"
  end

  test do
    system bin/"tmsu", "--version"
  end
end
__END__
diff --git a/src/github.com/oniony/TMSU/cli/commands.go b/src/github.com/oniony/TMSU/cli/commands.go
index 6d561f8..cc07677 100644
--- a/src/github.com/oniony/TMSU/cli/commands.go
+++ b/src/github.com/oniony/TMSU/cli/commands.go
@@ -13,7 +13,7 @@
 // You should have received a copy of the GNU General Public License
 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-// +build !windows
+// +build !windows,!darwin
 
 package cli
 
diff --git a/src/github.com/oniony/TMSU/cli/commands_darwin.go b/src/github.com/oniony/TMSU/cli/commands_darwin.go
new file mode 100644
index 0000000..18dd105
--- /dev/null
+++ b/src/github.com/oniony/TMSU/cli/commands_darwin.go
@@ -0,0 +1,41 @@
+// Copyright 2011-2015 Paul Ruane.
+
+// This program is free software: you can redistribute it and/or modify
+// it under the terms of the GNU General Public License as published by
+// the Free Software Foundation, either version 3 of the License, or
+// (at your option) any later version.
+
+// This program is distributed in the hope that it will be useful,
+// but WITHOUT ANY WARRANTY; without even the implied warranty of
+// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+// GNU General Public License for more details.
+
+// You should have received a copy of the GNU General Public License
+// along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+// +build darwin
+
+package cli
+
+// unexported
+
+var commands = []*Command{
+	&ConfigCommand,
+	&CopyCommand,
+	&DeleteCommand,
+	&DupesCommand,
+	&FilesCommand,
+	&HelpCommand,
+	&ImplyCommand,
+	&InfoCommand,
+	&InitCommand,
+	&MergeCommand,
+	&RenameCommand,
+	&RepairCommand,
+	&StatusCommand,
+	&TagCommand,
+	&TagsCommand,
+	&UntagCommand,
+	&UntaggedCommand,
+	&ValuesCommand,
+	&VersionCommand}
diff --git a/src/github.com/oniony/TMSU/cli/mount.go b/src/github.com/oniony/TMSU/cli/mount.go
index 85a3239..a4433f8 100644
--- a/src/github.com/oniony/TMSU/cli/mount.go
+++ b/src/github.com/oniony/TMSU/cli/mount.go
@@ -13,7 +13,7 @@
 // You should have received a copy of the GNU General Public License
 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-// +build !windows
+// +build !windows,!darwin
 
 package cli
 
diff --git a/src/github.com/oniony/TMSU/cli/unmount.go b/src/github.com/oniony/TMSU/cli/unmount.go
index 4bab91e..8d8f07d 100644
--- a/src/github.com/oniony/TMSU/cli/unmount.go
+++ b/src/github.com/oniony/TMSU/cli/unmount.go
@@ -13,7 +13,7 @@
 // You should have received a copy of the GNU General Public License
 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-// +build !windows
+// +build !windows,!darwin
 
 package cli
 
diff --git a/src/github.com/oniony/TMSU/cli/vfs.go b/src/github.com/oniony/TMSU/cli/vfs.go
index 9ea9bce..761ad82 100644
--- a/src/github.com/oniony/TMSU/cli/vfs.go
+++ b/src/github.com/oniony/TMSU/cli/vfs.go
@@ -13,7 +13,7 @@
 // You should have received a copy of the GNU General Public License
 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-// +build !windows
+// +build !windows,!darwin
 
 package cli
 
diff --git a/src/github.com/oniony/TMSU/vfs/fusevfs.go b/src/github.com/oniony/TMSU/vfs/fusevfs.go
index 08124dd..f2a4efe 100644
--- a/src/github.com/oniony/TMSU/vfs/fusevfs.go
+++ b/src/github.com/oniony/TMSU/vfs/fusevfs.go
@@ -13,7 +13,7 @@
 // You should have received a copy of the GNU General Public License
 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-// +build !windows
+// +build !windows,!darwin
 
 package vfs
 
diff --git a/src/github.com/oniony/TMSU/vfs/mtable.go b/src/github.com/oniony/TMSU/vfs/mtable.go
index 84cabc5..08dbf9e 100644
--- a/src/github.com/oniony/TMSU/vfs/mtable.go
+++ b/src/github.com/oniony/TMSU/vfs/mtable.go
@@ -13,7 +13,7 @@
 // You should have received a copy of the GNU General Public License
 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
-// +build !windows
+// +build !windows,!darwin
 
 package vfs
 
@@ -27,7 +27,7 @@ import (
 	"strings"
 )
 
-// +build !windows
+// +build !windows,!darwin
 
 type Mount struct {
 	DatabasePath string
