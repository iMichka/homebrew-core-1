class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.9/recode-3.7.9.tar.gz"
  sha256 "e4320a6b0f5cd837cdb454fb5854018ddfa970911608e1f01cc2c65f633672c4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9bca3845a8c324b5f9546c2c9de7881ee2a91b47513a39188fbc65d5c119b3bd"
    sha256 cellar: :any, big_sur:       "322571c853f461cd7f85afde9da5895996479b8aafddaa729081c10f4b319c57"
    sha256 cellar: :any, catalina:      "e049f7705d6f397a3a4bb87e31cc43eeb8ab7f0958b5efb3daccbab2a77aaa96"
    sha256 cellar: :any, mojave:        "27ba44840e12f588f741d2a7477ac8e6c6d3df22b09b426c617c87b98518d5c8"
  end

  depends_on "libtool" => :build
  depends_on "python@3.9" => :build
  depends_on "gettext"

  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
__END__
diff --git a/tables.py b/tables.py
index 5c42f21..9e40bac 100755
--- a/tables.py
+++ b/tables.py
@@ -197,12 +197,11 @@ class Charnames(Options):
 
     def digest_french(self, input):
         self.preset_french()
-        fold_table = range(256)
-        for before, after in map(
-                None,
+        fold_table = list(range(256))
+        for before, after in zip(
                 u'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÂÇÈÉÊÎÏÑÔÖÛ'.encode('ISO-8859-1'),
                 u'abcdefghijklmnopqrstuvwxyzàâçèéêîïñôöû'.encode('ISO-8859-1')):
-            fold_table[ord(before)] = ord(after)
+            fold_table[before] = after
         folding = ''.join(map(chr, fold_table))
         ignorables = (
                 u'<commande>'.encode('ISO-8859-1'),
@@ -264,7 +263,7 @@ class Charnames(Options):
             u"séparateur d'article (rs)",                        # 001E
             u"séparateur de sous-article (us)",                  # 001F
             ):
-            self.declare(ucs, text.encode('ISO-8859-1'))
+            self.declare(ucs, text)
             ucs += 1
         ucs = 0x007F
         for text in (
@@ -302,7 +301,7 @@ class Charnames(Options):
             u"message privé (pm)",                               # 009E
             u"commande de progiciel (apc)",                      # 009F
             ):
-            self.declare(ucs, text.encode('ISO-8859-1'))
+            self.declare(ucs, text)
             ucs += 1
 
     def declare(self, ucs, text):
@@ -329,17 +328,15 @@ class Charnames(Options):
         # bytes, the first one running slowly from singles+1 to 255,
         # the second cycling faster from 1 to 255.
         sys.stderr.write('  sorting words...')
-        pairs = map(self.presort_word, self.code_map.keys())
-        pairs.sort()
-        words = map(lambda pair: pair[1], pairs)
+        pairs = sorted(map(self.presort_word, self.code_map.keys()))
+        words = list(map(lambda pair: pair[1], pairs))
         pairs = None
         sys.stderr.write(' %d of them\n' % len(words))
         count = len(words)
-        singles = (255 * 255 - count) / 254
+        singles = (255 * 255 - count) // 254
         # Transmit a few values for further usage by the C code.
         sys.stderr.write('  sorting names...')
-        ucs2_table = self.charname_map.keys()
-        ucs2_table.sort()
+        ucs2_table = sorted(self.charname_map.keys())
         sys.stderr.write(' %d of them\n' % len(ucs2_table))
         write('\n'
               '#define NUMBER_OF_SINGLES %d\n'
@@ -389,7 +386,7 @@ class Charnames(Options):
                     if code < 256:
                         write('\\%0.3o' % code)
                     else:
-                        write('\\%0.3o\\%0.3o' % (code / 256, code % 256))
+                        write('\\%0.3o\\%0.3o' % (code // 256, code % 256))
                 else:
                     sys.stderr.write('??? %s\n' % word)
             write('"},\n')
@@ -659,8 +656,7 @@ class Mnemonics(Options):
               'static const struct entry table[TABLE_LENGTH] =\n'
               '  {\n')
         count = 0
-        indices = self.mnemonic_map.keys()
-        indices.sort()
+        indices = sorted(self.mnemonic_map.keys())
         for ucs2 in indices:
             text = self.mnemonic_map[ucs2]
             inverse_map[text] = count
@@ -673,8 +669,7 @@ class Mnemonics(Options):
               'static const unsigned short inverse[TABLE_LENGTH] =\n'
               '  {')
         count = 0
-        keys = inverse_map.keys()
-        keys.sort()
+        keys = sorted(inverse_map.keys())
         for text in keys:
             if count % 10 == 0:
                 if count != 0:
@@ -1122,8 +1117,7 @@ class Strips(Options):
             write = Output('fr-%s' % self.TEXINFO, noheader=True).write
         else:
             write = Output(self.TEXINFO, noheader=True).write
-        charsets = self.remark_map.keys()
-        charsets.sort()
+        charsets = sorted(self.remark_map.keys())
         for charset in charsets:
             write('\n'
                   '@item %s\n'
@@ -1158,13 +1152,15 @@ class Input:
 
     def __init__(self, name):
         self.name = name
-        self.input = file(name)
+        self.input = open(name, encoding='latin-1')
         self.line_count = 0
         sys.stderr.write("Reading %s\n" % name)
 
     def readline(self):
         self.line = self.input.readline()
         self.line_count += 1
+        if type(self.line) == bytes:
+            self.line = self.line.decode('utf-8')
         return self.line
 
     def warn(self, format, *args):
@@ -1189,7 +1185,7 @@ class Output:
 
     def __init__(self, name, noheader=False):
         self.name = name
-        self.write = file(name, 'w').write
+        self.write = open(name, 'w', encoding='utf-8').write
         sys.stderr.write("Writing %s\n" % name)
         if not noheader:
             self.write("""\
