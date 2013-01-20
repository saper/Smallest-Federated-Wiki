# {"slug": ["slug"]}
linkmap = {}

# {nodes: [{name: string, group: 1}] links: [{source: 0, target: 33, value: 6}]}
forceData = ->
	nodes = []
	links = []
	nodeNum = {}
	for slug of linkmap
		nodeNum[slug] = nodes.length
		nodes.push {name: slug, group: 1}
	for slug, slugs of linkmap
		source = nodeNum[slug]
		for link in slugs
			if (target = nodeNum[link])?
				links.push({source, target, value: 6})
	{nodes, links}


emit = ($item, item) ->
	$item.append """<p>Hello Linkmap</p>"""

bind = ($item, item) ->
  $item.addClass 'force-source'
  $item.get(0).forceData = forceData

	socket = new WebSocket('ws://'+window.document.location.host+'/plugin/linkmap')

	progress = (m) ->
	  wiki.log 'linkmap', m

	socket.onopen = ->
	  progress "opened"

	socket.onmessage = (e) ->
	  linkmap = JSON.parse e.data
	  socket.close()

	socket.onclose = ->
	  progress "closed"


window.plugins.linkmap = {emit, bind}