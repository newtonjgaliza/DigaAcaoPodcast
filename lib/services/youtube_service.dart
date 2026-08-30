import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../models/youtube_video.dart';

class YoutubeService {
  static const String channelId = 'UC3hu56IlQRI7GRJJRoaE6vQ';
  static const String rssUrl = 'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';

  // Hardcoded fallback list containing the actual 15 videos fetched from the channel
  static final List<YoutubeVideo> _fallbackVideos = [
    YoutubeVideo(
      id: 'oQy-R324RLE',
      title: 'Detalhes que você NÃO VIU! | Lanternas EP #1',
      thumbnailUrl: 'https://img.youtube.com/vi/oQy-R324RLE/hqdefault.jpg',
      publishedAt: '25/08/2026',
      url: 'https://www.youtube.com/watch?v=oQy-R324RLE',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'Yu4cVCHKEPg',
      title: 'As etapas e os desafios de desenvolver um Jogo! (Part. Dev. @Raphael Tiritan) | Ep #102',
      thumbnailUrl: 'https://img.youtube.com/vi/Yu4cVCHKEPg/hqdefault.jpg',
      publishedAt: '21/08/2026',
      url: 'https://www.youtube.com/watch?v=Yu4cVCHKEPg',
      isShort: false,
    ),
    YoutubeVideo(
      id: '4kO27gB90xA',
      title: 'Foi Decepcionante ou Não? | Nossa Opinião sobre A Casa do Dragão 3ª temp.',
      thumbnailUrl: 'https://img.youtube.com/vi/4kO27gB90xA/hqdefault.jpg',
      publishedAt: '17/08/2026',
      url: 'https://www.youtube.com/watch?v=4kO27gB90xA',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'pTs-m4UIX8A',
      title: 'Desenhos com Temática Subliminar | EP #101',
      thumbnailUrl: 'https://img.youtube.com/vi/pTs-m4UIX8A/hqdefault.jpg',
      publishedAt: '14/08/2026',
      url: 'https://www.youtube.com/watch?v=pTs-m4UIX8A',
      isShort: false,
    ),
    YoutubeVideo(
      id: '76SoaxgNbi0',
      title: 'Melhorou Bastante! Homem Aranha: Um novo dia | Nossa opinião C/ Spoilers.',
      thumbnailUrl: 'https://img.youtube.com/vi/76SoaxgNbi0/hqdefault.jpg',
      publishedAt: '12/08/2026',
      url: 'https://www.youtube.com/watch?v=76SoaxgNbi0',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'XGn63qYcjjU',
      title: 'Opiniões Impopulares! | ESPECIAL EP #100 (Part. @afronteiranerd )',
      thumbnailUrl: 'https://img.youtube.com/vi/XGn63qYcjjU/hqdefault.jpg',
      publishedAt: '08/08/2026',
      url: 'https://www.youtube.com/watch?v=XGn63qYcjjU',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'DC25MT3LCDE',
      title: 'BRAND NEW DAY É BOM MESMO?!',
      thumbnailUrl: 'https://img.youtube.com/vi/DC25MT3LCDE/hqdefault.jpg',
      publishedAt: '04/08/2026',
      url: 'https://www.youtube.com/shorts/DC25MT3LCDE',
      isShort: true,
    ),
    YoutubeVideo(
      id: 'uGSveH2f5Yw',
      title: 'Cantor Will Kawamura | Carreira, Curiosidades, Ele fez parte da nossa Infância!! | Ep# 99',
      thumbnailUrl: 'https://img.youtube.com/vi/uGSveH2f5Yw/hqdefault.jpg',
      publishedAt: '31/07/2026',
      url: 'https://www.youtube.com/watch?v=uGSveH2f5Yw',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'vGWYn9YWXuU',
      title: 'Tem muito Coisa Escondida! | Análise e Curiosidades do Trailer de Doomsday',
      thumbnailUrl: 'https://img.youtube.com/vi/vGWYn9YWXuU/hqdefault.jpg',
      publishedAt: '24/07/2026',
      url: 'https://www.youtube.com/watch?v=vGWYn9YWXuU',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'RSbaaYCWSR4',
      title: 'VALE A PENA VOLTAR PRO PALWORD 1.0??',
      thumbnailUrl: 'https://img.youtube.com/vi/RSbaaYCWSR4/hqdefault.jpg',
      publishedAt: '24/07/2026',
      url: 'https://www.youtube.com/shorts/RSbaaYCWSR4',
      isShort: true,
    ),
    YoutubeVideo(
      id: 'DZwXYp6g12U',
      title: 'Avatar da Netflix "Decepcionou" de novo? | Nossa opinião com Spoilers',
      thumbnailUrl: 'https://img.youtube.com/vi/DZwXYp6g12U/hqdefault.jpg',
      publishedAt: '20/07/2026',
      url: 'https://www.youtube.com/watch?v=DZwXYp6g12U',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'gPpY8PsZ-1M',
      title: 'Como foi criar um grande universo de ficção cientifica!! | Serie Control (Part. C. P Torber) EP #98',
      thumbnailUrl: 'https://img.youtube.com/vi/gPpY8PsZ-1M/hqdefault.jpg',
      publishedAt: '17/07/2026',
      url: 'https://www.youtube.com/watch?v=gPpY8PsZ-1M',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'S_z0DSUzpZw',
      title: 'Filmes de TERROR que revolucionaram o Gênero! | Ep #97',
      thumbnailUrl: 'https://img.youtube.com/vi/S_z0DSUzpZw/hqdefault.jpg',
      publishedAt: '12/07/2026',
      url: 'https://www.youtube.com/watch?v=S_z0DSUzpZw',
      isShort: false,
    ),
    YoutubeVideo(
      id: 'QJhw6VE2T_E',
      title: 'Como ter uma carreira de Sucesso no Cosplay (Part. @Fabio Leonardo) | Direto da @animecon | EP #96',
      thumbnailUrl: 'https://img.youtube.com/vi/QJhw6VE2T_E/hqdefault.jpg',
      publishedAt: '03/07/2026',
      url: 'https://www.youtube.com/watch?v=QJhw6VE2T_E',
      isShort: false,
    ),
    YoutubeVideo(
      id: '6EGBgQqkSYA',
      title: 'QUEM FOI O PRIMEIRO MUTANTE??',
      thumbnailUrl: 'https://img.youtube.com/vi/6EGBgQqkSYA/hqdefault.jpg',
      publishedAt: '30/06/2026',
      url: 'https://www.youtube.com/shorts/6EGBgQqkSYA',
      isShort: true,
    ),
  ];

  Future<List<YoutubeVideo>> fetchVideos() async {
    try {
      // In web, standard RSS request might fail due to CORS.
      // We will perform the request and catch failures to return the fallback list.
      final response = await http.get(Uri.parse(rssUrl)).timeout(const Duration(seconds: 7));
      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final entries = document.findAllElements('entry');
        
        final List<YoutubeVideo> list = [];
        for (var entry in entries) {
          final videoId = entry.findElements('yt:videoId').firstOrNull?.innerText ?? '';
          final title = entry.findElements('title').firstOrNull?.innerText ?? 'Sem título';
          
          String link = entry.findElements('link').firstOrNull?.getAttribute('href') ?? '';
          final isShort = link.contains('/shorts/');
          
          if (link.isEmpty) {
            link = isShort ? 'https://www.youtube.com/shorts/$videoId' : 'https://www.youtube.com/watch?v=$videoId';
          }
          
          final mediaGroup = entry.findElements('media:group').firstOrNull;
          final thumbnailElement = mediaGroup?.findElements('media:thumbnail').firstOrNull;
          final thumbnailUrl = thumbnailElement?.getAttribute('url') ?? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
          
          final publishedElement = entry.findElements('published').firstOrNull;
          String publishedAt = 'Recente';
          if (publishedElement != null) {
            try {
              final dateTime = DateTime.parse(publishedElement.innerText);
              publishedAt = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
            } catch (_) {}
          }
          
          if (videoId.isNotEmpty) {
            list.add(YoutubeVideo(
              id: videoId,
              title: title,
              thumbnailUrl: thumbnailUrl,
              publishedAt: publishedAt,
              url: link,
              isShort: isShort,
            ));
          }
        }
        
        if (list.isNotEmpty) {
          return list;
        }
      }
    } catch (e) {
      // Network issues or CORS error, proceed to fallback list
      print('Erro ao buscar vídeos do RSS: $e. Retornando fallback.');
    }
    
    // Return a clone of fallback videos
    return List.from(_fallbackVideos);
  }
}
